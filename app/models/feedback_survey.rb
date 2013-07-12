# == Schema Information
#
# Table name: feedback_surveys
#
#  id                  :integer          not null, primary key
#  code                :string(255)      not null
#  feedback_type       :string(255)
#  feedback_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  feedback_controller :string(255)
#  design_id           :integer
#  is_approved         :boolean          default(FALSE)
#

class FeedbackSurvey < ActiveRecord::Base
  # callbacks
  #before_validation :validate_code, :on => :create
  before_create :find_design
  after_create :reset_boxarea!
  # acceesible
  attr_accessible :code, :feedback_type, :feedback_controller
  # Associations
  belongs_to :design
  belongs_to :feedback, :polymorphic => true
  has_one :imported_assignment, :class_name => "Turkee::TurkeeImportedAssignment", :foreign_key => "result_id"
  has_many :boxareas
  # Validations
  validates :code, :presence => {:message => "Code is required"}
  #validates :feedback_type, :presence => {:message => "Feedback type is required"}
  #validates :feedback_id, :presence => {:message => "Feedback ID is required"}
  validates :feedback_controller, :presence => {:message => "Feedback controller is required"}

  def approve?
    is_valid = !self.boxareas.empty?
    if is_valid
      self.is_approved = true
      self.save!
    end
    return is_valid
  end

  def self.hit_complete(turkee_task)
    if design = Design.where("element_feedbacks_hit_id=?", turkee_task.id).first
      design.finish_feedback("ElementFeedbacks")
    end

    if design = Design.where("first_notice_feedbacks_hit_id=?", turkee_task.id).first
      design.finish_feedback("FirstNoticeFeedbacks")
    end

    if design = Design.where("impression_feedbacks_hit_id=?", turkee_task.id).first
      design.finish_feedback("ImpressionFeedbacks")
    end

    if design = Design.where("impression_vote_feedbacks_hit_id=?", turkee_task.id).first
      design.finish_feedback("ImpressionVoteFeedbacks")
    end

    if design = Design.where("goal_feedbacks_hit_id=?", turkee_task.id).first
      design.finish_feedback("GoalFeedbacks")
    end

    if design = Design.where("guideline_feedbacks_hit_id=?", turkee_task.id).first
      design.finish_feedback("GuidelineFeedbacks")
    end
  end

  def self.hit_expired(turkee_task)

  end

  protected
  def validate_code
    return !Boxarea.where(:code => self.code.strip).empty?
  end

  def find_design
    boxarea = Boxarea.where(:code => self.code.strip).first
    if boxarea
      design = boxarea.feedback.design
      self.design = design
    end
  end

  def reset_boxarea!
    Boxarea.where(:code => self.code.strip).each do |boxarea|
      boxarea.feedback_survey = self
      boxarea.code = nil
      boxarea.save!
    end
  end
end
