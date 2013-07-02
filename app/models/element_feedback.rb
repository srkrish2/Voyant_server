# == Schema Information
#
# Table name: element_feedbacks
#
#  id               :integer          not null, primary key
#  design_id        :integer          not null
#  configuration_id :integer          not null
#  name             :string(255)      not null
#  vote             :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  code             :string(255)
#

require "models/feedback_with_code"

class ElementFeedback < ActiveRecord::Base
  include FeedbackWithCode
  # callbacks
  before_create :generate_code
  # Accessible
  attr_accessible :name
  # Associations
  has_many :boxareas, :as => :feedback, :dependent => :destroy
  belongs_to :design
  belongs_to :configuration, :class_name => "ElementConfiguration"
  has_many :first_notice_feedbacks, :dependent => :destroy
  has_one :survey, :class_name => "FeedbackSurvey", :as => :feedback, :dependent => :destroy
  # Validations
  validates :design_id, :presence => {:message => "Design is required"}
  validates :configuration_id, :presence => {:message => "Configuration is required"}
  validates :name, :presence => {:message => "Name is required"}
end
