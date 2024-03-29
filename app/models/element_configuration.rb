# == Schema Information
#
# Table name: element_configurations
#
#  id            :integer          not null, primary key
#  design_id     :integer          not null
#  name          :string(255)      not null
#  is_required   :boolean          default(TRUE)
#  turker_num    :integer          default(0)
#  turker_price  :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feedbacks_num :integer          default(5)
#

class ElementConfiguration < ActiveRecord::Base
  # Accessible
  attr_accessible :name, :is_required, :turker_num, :turker_price
  # Associations
  belongs_to :design
  has_many :feedbacks, :class_name =>  "ElementFeedback", :foreign_key => :configuration_id, :dependent => :destroy
  # Validations
  validates :design_id, :presence => {:message => "Design is required"}
  validates :name, :presence => {:message => "Name is required"}
end
