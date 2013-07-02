# == Schema Information
#
# Table name: goal_feedbacks
#
#  id               :integer          not null, primary key
#  design_id        :integer          not null
#  configuration_id :integer          not null
#  rating           :integer          default(1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  code             :string(255)
#

require "models/feedback_with_code"

class GoalFeedback < ActiveRecord::Base
  include FeedbackWithCode
  # callbacks
  before_create :generate_code
  # Accessible
  attr_accessible :rating
  # Associations
  has_one :boxarea, :as => :feedback, :dependent => :destroy
  belongs_to :design
  belongs_to :configuration, :class_name => "GoalConfiguration"
  has_one :survey, :class_name => "FeedbackSurvey", :as => :feedback, :dependent => :destroy
  #validations
  validates :design_id, :presence => {:message => "Design is required"}
  validates :configuration_id, :presence => {:message => "Configuration ID is required"}
end
