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
#

class GoalFeedback < ActiveRecord::Base
  # Accessible
  #attr_accessible :rating
  # Associations
  has_many :boxareas, :as => :feedback, :dependent => :destroy
  belongs_to :design
  belongs_to :configuration, :class_name => "GoalConfiguration"
end
