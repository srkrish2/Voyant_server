# == Schema Information
#
# Table name: impression_configurations
#
#  id            :integer          not null, primary key
#  design_id     :integer          not null
#  is_required   :boolean          default(TRUE)
#  turker_num1   :integer          default(0)
#  turker_price1 :float            default(0.0)
#  turker_num2   :integer          default(0)
#  turker_price2 :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ImpressionConfiguration < ActiveRecord::Base
  # Accessible
  attr_accessible :is_required, :turker_num1, :turker_price1, :turker_num2, :turker_price2
  # Associations
  belongs_to :design
end
