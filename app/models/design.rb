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


  def publish!
    self.generate_feedbacks_access_codes
    self.is_published = true
    # create HIT
    form_url = survey_design_element_feedbacks_url(self, :access_code => self.element_feedbacks_access_code)
    hit = self.create_hit!(form_url: form_url)
    self.element_feedbacks_hit = hit
    self.save!
  end

  def finish_feedback(feedback_controller)
    case feedback_controller
    when "ElementFeedbacks"
      form_url = survey_design_first_notice_feedbacks_url(self, :access_code => self.first_notice_feedbacks_access_code)
      hit = self.create_hit!(form_url: form_url)
      self.first_notice_feedbacks_hit = hit

      form_url = survey_design_impression_feedbacks_url(self, :access_code => self.impression_feedbacks_access_code)
      hit = self.create_hit!(form_url: form_url)
      self.impression_feedbacks_hit = hit

      form_url = survey_design_goal_feedbacks_url(self, :access_code => self.goal_feedbacks_access_code)
      hit = self.create_hit!(form_url: form_url)
      self.goal_feedbacks_hit = hit

      form_url = survey_design_guideline_feedbacks_url(self, :access_code => self.guideline_feedbacks_access_code)
      hit = self.create_hit!(form_url: form_url)
      self.guideline_feedbacks_hit = hit

      self.save!
    when "FirstNoticeFeedbacks"
    when "ImpressionFeedbacks"
      form_url = survey_design_impression_vote_feedbacks_url(self, :access_code => self.impression_vote_feedbacks_access_code)
      hit = self.create_hit!(form_url: form_url)
      self.impression_vote_feedbacks_hit = hit

      self.save!
    when "ImpressionVoteFeedbacks"
    when "GoalFeedbacks"
    when "GuidelineFeedbacks"
    end

    self.check_feedback_finish!
  end

  protected
  def generate_feedbacks_access_codes
    self.element_feedbacks_access_code = rand_code
    self.first_notice_feedbacks_access_code = rand_code
    self.impression_feedbacks_access_code = rand_code
    self.impression_vote_feedbacks_access_code = rand_code
    self.goal_feedbacks_access_code = rand_code
    self.guideline_feedbacks_access_code = rand_code
  end

  def create_hit!(options)
    title = options[:title] || "Design Feedbacks: #{self.name}"
    description = options[:description] || self.description
    num_assignments = options[:num_assignments] || 1
    reward = options[:reward] || 0.05
    lifetime = options[:lifetime] || 7.days.seconds
    duration = options[:duration] || 24.hours.seconds
    form_url = options[:form_url] || (raise "No form_url provided")

    h = RTurk::Hit.create do |hit|
      hit.title = title
      hit.description = description
      hit.assignments = num_assignments
      hit.reward = reward
      hit.lifetime = lifetime.to_i
      hit.duration = duration.to_i
      hit.question(form_url, :frame_height => 300)
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
