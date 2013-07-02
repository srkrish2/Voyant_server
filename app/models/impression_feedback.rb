# == Schema Information
#
# Table name: impression_feedbacks
#
#  id         :integer          not null, primary key
#  design_id  :integer          not null
#  name       :string(255)      not null
#  vote       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code       :string(255)
#

require "models/feedback_with_code"

class ImpressionFeedback < ActiveRecord::Base
  include FeedbackWithCode
  # callbacks
  before_create :generate_code
  # Accessible
  attr_accessible :name
  # Association
  has_many :boxareas, :as => :feedback, :dependent => :destroy
  belongs_to :design
  has_one :survey, :class_name => "FeedbackSurvey", :as => :feedback, :dependent => :destroy
end
