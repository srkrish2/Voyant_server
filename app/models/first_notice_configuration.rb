# == Schema Information
#
# Table name: first_notice_configurations
#
#  id            :integer          not null, primary key
#  design_id     :integer          not null
#  is_required   :boolean          default(TRUE)
#  turker_num    :integer          default(0)
#  turker_price  :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feedbacks_num :integer          default(30)
#

class FirstNoticeConfiguration < ActiveRecord::Base
  # Accessible
  attr_accessible :is_required, :turker_num, :turker_price
  # Associations
  belongs_to :design
end
