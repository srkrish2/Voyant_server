# == Schema Information
#
# Table name: guideline_configurations
#
#  id            :integer          not null, primary key
#  design_id     :integer          not null
#  title         :string(255)      not null
#  description   :text
#  is_required   :boolean          default(TRUE)
#  turker_num    :integer          default(0)
#  turker_price  :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feedbacks_num :integer          default(20)
#

class GuidelineConfiguration < ActiveRecord::Base
  # Accessible
  attr_accessible :title, :description, :is_required, :turker_num, :turker_price
  # Associations
  belongs_to :design
  has_many :feedbacks, :class_name => "GuidelineFeedback", :foreign_key => :configuration_id, :dependent => :destroy
end
