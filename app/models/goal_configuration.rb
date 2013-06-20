# == Schema Information
#
# Table name: goal_configurations
#
#  id           :integer          not null, primary key
#  design_id    :integer          not null
#  title        :string(255)      not null
#  description  :text
#  is_required  :boolean          default(TRUE)
#  turker_num   :integer          default(0)
#  turker_price :float            default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class GoalConfiguration < ActiveRecord::Base
  # attr_accessible :title, :body
end
