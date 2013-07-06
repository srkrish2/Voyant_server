# == Schema Information
#
# Table name: designs
#
#  id                                    :integer          not null, primary key
#  project_id                            :integer
#  user_id                               :integer          not null
#  name                                  :string(255)      not null
#  description                           :text
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  picture_file_name                     :string(255)
#  picture_content_type                  :string(255)
#  picture_file_size                     :integer
#  picture_updated_at                    :datetime
#  is_published                          :boolean          default(FALSE)
#  element_feedbacks_access_code         :string(255)
#  first_notice_feedbacks_access_code    :string(255)
#  impression_feedbacks_access_code      :string(255)
#  goal_feedbacks_access_code            :string(255)
#  guideline_feedbacks_access_code       :string(255)
#  impression_vote_feedbacks_access_code :string(255)
#  element_feedbacks_hit_id              :integer
#  first_notice_feedbacks_hit_id         :integer
#  impression_feedbacks_hit_id           :integer
#  impression_vote_feedbacks_hit_id      :integer
#  goal_feedbacks_hit_id                 :integer
#  guideline_feedbacks_hit_id            :integer
#  is_feedback_done                      :boolean          default(FALSE)
#

require "models/rand_code"

class Design < ActiveRecord::Base
  include RandCode
  include Rails.application.routes.url_helpers
  # callbacks
  after_destroy :expire_all_hit!
  # Accessible
  attr_accessible :picture, :name, :description
  # Associations
  has_attached_file :picture, :styles => {:medium => "300x300", :thumb => "100x100"}, :default_url => "/images/:style/missing.png"
  belongs_to :user
  belongs_to :project
  has_one :audience_configuration, :dependent => :destroy
  has_many :element_configurations, :dependent => :destroy
  has_one :first_notice_configuration, :dependent => :destroy
  has_one :impression_configuration, :dependent => :destroy
  has_many :goal_configurations, :dependent => :destroy
  has_many :guideline_configurations, :dependent => :destroy

  has_many :element_feedbacks, :dependent => :destroy
  has_many :first_notice_feedbacks, :dependent => :destroy
  has_many :impression_feedbacks, :dependent => :destroy
  has_many :goal_feedbacks, :dependent => :destroy
  has_many :guideline_feedbacks, :dependent => :destroy

  belongs_to :element_feedbacks_hit, :class_name => "Turkee::TurkeeTask"
  belongs_to :first_notice_feedbacks_hit, :class_name => "Turkee::TurkeeTask"
  belongs_to :impression_feedbacks_hit, :class_name => "Turkee::TurkeeTask"
  belongs_to :impression_vote_feedbacks_hit, :class_name => "Turkee::TurkeeTask"
  belongs_to :goal_feedbacks_hit, :class_name => "Turkee::TurkeeTask"
  belongs_to :guideline_feedbacks_hit, :class_name => "Turkee::TurkeeTask"

  has_many :feedback_surveys, :dependent => :destroy
  # Validations
  validates :user_id, :presence => { :message => "User is required" }
  validates :name, :presence => {:message => "Name is required" }
  validates_attachment :picture, :presence => true,
                                 :content_type => { :content_type => ["image/jpg", "image/jpeg","image/png"] }


  def publish!
    self.generate_feedbacks_access_codes
    self.is_published = true
    # create HIT
    self.create_hit_with_type!("ElementFeedbacks", {num_assignments: self.element_configurations.count * 5})
  end

  def finish_feedback(feedback_controller)
    case feedback_controller
    when "ElementFeedbacks"
      self.create_hit_with_type!("FirstNoticeFeedbacks", {num_assignments: 30})

      self.create_hit_with_type!("ImpressionFeedbacks", {num_assignments: 20})

      num_assignments = 0
      self.goal_configurations.each {|configuration| num_assignments += configuration.feedbacks_num}
      self.create_hit_with_type!("GoalFeedbacks", {num_assignments: num_assignments})

      num_assignments = 0
      self.guideline_configurations.each {|configuration| num_assignments += configuration.feedbacks_num}
      self.create_hit_with_type!("GuidelineFeedbacks", {num_assignments: num_assignments})

    when "FirstNoticeFeedbacks"
    when "ImpressionFeedbacks"
      self.create_hit_with_type!("ImpressionVoteFeedbacks", {num_assignments: 30})
    when "ImpressionVoteFeedbacks"
    when "GoalFeedbacks"
    when "GuidelineFeedbacks"
    end

    self.check_feedback_finish!
  end


  def self.process_hits
    puts "Process Hits #{Time.now}============================================"
    hits = RTurk::Hit.all_reviewable
    puts "#{hits.size} reviewable hits."
    hits.each do |hit|
      puts "HIT ID: #{hit.id}"
      task = Turkee::TurkeeTask.where(:hit_id => hit.id).first
      Turkee::TurkeeTask.process_hits(task)
      puts "Task ID: #{task.id}"

      if design = Design.where(:element_feedbacks_hit_id => task.id).first
        feedback_type = "ElementFeedbacks"
      elsif design = Design.where(:first_notice_feedbacks_hit_id => task.id).first
        feedback_type = "FirstNoticeFeedbacks"
      elsif design = Design.where(:impression_feedbacks_hit_id => task.id).first
        feedback_type = "ImpressionFeedbacks"
      elsif design = Design.where(:impression_vote_feedbacks_hit_id => task.id).first
        feedback_type = "ImpressionVoteFeedbacks"
      elsif design = Design.where(:goal_feedbacks_hit_id => task.id).first
        feedback_type = "GoalFeedbacks"
      elsif design = Design.where(:guideline_feedbacks_hit_id => task.id).first
        feedback_type = "GuidelineFeedbacks"
      end

      approve_num = FeedbackSurvey.joins(:imported_assignment).where("design_id=:design_id 
                                                                     AND feedback_controller=:feedback_type 
                                                                     AND is_approved=:is_approved 
                                                                     AND turkee_task_id=:task_id",
                                                                    :design_id => design.id,
                                                                    :feedback_type => feedback_type,
                                                                    :is_approved => true,
                                                                    :task_id => task.id).count
      not_process_num = task.hit_num_assignments - approve_num

      if not_process_num > 0
        old_task = design.send("#{feedback_type.underscore}_hit")
        if !old_task.complete
          RTurk::Hit.new(old_task.hit_id).dispose!
          old_task.expired = true
          old_task.save!
        end
        design.create_hit_with_type!(feedback_type, {num_assignments: not_process_num})
      end
    end
  end

  def expire_hit!(task)
    hit = RTurk::Hit.new(task.hit_id)
    hit.expire!
    hit.dispose!
    task.expired = true
    task.save!
  end

  def create_hit_with_type!(feedback_type, options)
    form_url = send("survey_design_#{feedback_type.underscore}_url", self, :access_code => self.send("#{feedback_type.underscore}_access_code"))
    hit = self.create_hit!(form_url: form_url, title: "#{feedback_type.underscore.split("_").join(" ")} - #{self.name} (#{self.id})", num_assignments: options[:num_assignments])
    self.send("#{feedback_type.underscore}_hit=",hit)
    self.save!
  end

  protected
  def expire_all_hit!
    self.expire_hit!(self.element_feedbacks_hit) if self.element_feedbacks_hit
    self.expire_hit!(self.first_notice_feedbacks_hit) if self.first_notice_feedbacks_hit
    self.expire_hit!(self.impression_feedbacks_hit) if self.impression_feedbacks_hit
    self.expire_hit!(self.impression_vote_feedbacks_hit) if self.impression_vote_feedbacks_hit
    self.expire_hit!(self.goal_feedbacks_hit) if self.goal_feedbacks_hit
    self.expire_hit!(self.guideline_feedbacks_hit) if self.guideline_feedbacks_hit
  end

  def generate_feedbacks_access_codes
    self.element_feedbacks_access_code = rand_code
    self.first_notice_feedbacks_access_code = rand_code
    self.impression_feedbacks_access_code = rand_code
    self.impression_vote_feedbacks_access_code = rand_code
    self.goal_feedbacks_access_code = rand_code
    self.guideline_feedbacks_access_code = rand_code
  end

  def create_hit!(options)
    title = options[:title] || "#{self.name}"
    title = "Design Feedback: #{title}"
    description = options[:description] || self.description
    num_assignments = options[:num_assignments] || 1
    reward = options[:reward] || 0.06
    lifetime = options[:lifetime] || 1.hours.seconds
    duration = options[:duration] || 5.minutes.seconds
    form_url = options[:form_url] || (raise "No form_url provided")

    h = RTurk::Hit.create do |hit|
      hit.title = title
      hit.description = description
      hit.assignments = num_assignments
      hit.reward = reward
      hit.lifetime = lifetime.to_i
      hit.duration = duration.to_i
      hit.question(form_url, :frame_height => 300)
      hit.qualifications.add :approval_rate, { :gt => 95 }
      #unless qualifications.empty?
        #qualifications.each do |key, value|
          #hit.qualifications.add key, value
        #end
      #end
    end

    # create TurkeeTask
    task = Turkee::TurkeeTask.create!(:sandbox => RTurk.sandbox?,
                     :hit_title => title,
                     :hit_description => description,
                     :hit_reward => reward.to_f,
                     :hit_num_assignments => num_assignments.to_i,
                     :hit_lifetime => lifetime,
                     :hit_duration => duration,
                     :form_url => form_url,
                     :hit_url => h.url,
                     :hit_id => h.id,
                     :task_type => "FeedbackSurvey",
                     :complete => false
                     )
    return task

  end

  def check_feedback_finish!
    finish = true

    finish = false if self.element_feedbacks_hit.nil? || !self.element_feedbacks_hit.complete
    
    finish = false if self.first_notice_feedbacks_hit.nil? || !self.first_notice_feedbacks_hit.complete

    finish = false if self.impression_feedbacks_hit.nil? || !self.impression_feedbacks_hit.complete

    finish = false if self.impression_vote_feedbacks_hit.nil? || !self.impression_vote_feedbacks_hit.complete

    finish = false if self.goal_feedbacks_hit.nil? || !self.goal_feedbacks_hit.complete

    finish = false if self.guideline_feedbacks_hit.nil? || !self.guideline_feedbacks_hit.complete

    self.is_feedback_done = finish

    self.save!

  end
end
