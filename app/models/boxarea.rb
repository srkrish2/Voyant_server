# == Schema Information
#
# Table name: boxareas
#
#  id             :integer          not null, primary key
#  turker_id      :integer          not null
#  feedback_id    :integer          not null
#  feedback_type  :string(255)      not null
#  top_left_x     :float            not null
#  top_left_y     :float            not null
#  bottom_right_x :float            not null
#  bottom_right_y :float            not null
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Boxarea < ActiveRecord::Base
  # Accessible
  attr_accessible :top_left_x, :top_left_y, :bottom_right_x, :bottom_right_y, :description
  # Associations
  belongs_to :turker
  belongs_to :feedback, :polymorphic => true
  # Validations
end
