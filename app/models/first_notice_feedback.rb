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
  has_many :boxareas, :as => :feedback, :dependent => :destroy
end
