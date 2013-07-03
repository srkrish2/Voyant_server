# == Schema Information
#
# Table name: boxareas
#
#  id                 :integer          not null, primary key
#  turker_id          :integer          not null
#  feedback_id        :integer          not null
#  feedback_type      :string(255)      not null
#  top_left_x         :float            not null
#  top_left_y         :float            not null
#  bottom_right_x     :float            not null
#  bottom_right_y     :float            not null
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  code               :string(255)
#  feedback_survey_id :integer
#

class Boxarea < ActiveRecord::Base
  # Accessible
  attr_accessible :top_left_x, :top_left_y, :bottom_right_x, :bottom_right_y, :description
  # Associations
  belongs_to :turker
  belongs_to :feedback, :polymorphic => true
  belongs_to :feedback_survey
  # Validations
  validates :turker_id, :presence => {:message => "Turker ID is required"}
  validates :feedback_id, :presence => {:message => "Feedback ID is required"}
  validates :feedback_type, :presence => {:message => "Feedback Type is required"}
  validates :top_left_x, :presence => {:message => "Top left x is required"}
  validates :top_left_y, :presence => {:message => "Top left y is required"}
  validates :bottom_right_x, :presence => {:message => "Bottom right x is required"}
  validates :bottom_right_y, :presence => {:message => "Bottom right y is required"}
end
