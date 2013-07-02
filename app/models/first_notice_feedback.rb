# == Schema Information
#
# Table name: first_notice_feedbacks
#
#  id                  :integer          not null, primary key
#  design_id           :integer          not null
#  element_feedback_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  code                :string(255)
#

require "models/feedback_with_code"

class FirstNoticeFeedback < ActiveRecord::Base
  include FeedbackWithCode
  # callbacks
  before_create :generate_code
  # Associations
  has_one :boxarea, :as => :feedback, :dependent => :destroy
  belongs_to :element_feedback
  belongs_to :design
  has_one :survey, :class_name => "FeedbackSurvey", :as => :feedback, :dependent => :destroy
  # Validations
  validates :design_id, :presence => {:message => "Design ID is required"}
  validates :element_feedback_id, :presence => {:message => "Element Feedback ID is required"}
end
