# == Schema Information
#
# Table name: first_notice_feedbacks
#
#  id                  :integer          not null, primary key
#  design_id           :integer          not null
#  element_feedback_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class FirstNoticeFeedback < ActiveRecord::Base
  # Associations
  has_one :boxarea, :as => :feedback, :dependent => :destroy
  belongs_to :element_feedback
  belongs_to :design
  # Validations
  validates :design_id, :presence => {:message => "Design ID is required"}
  validates :element_feedback_id, :presence => {:message => "Element Feedback ID is required"}
end
