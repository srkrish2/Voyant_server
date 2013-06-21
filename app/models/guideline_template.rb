# == Schema Information
#
# Table name: guideline_templates
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  title       :string(255)      not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GuidelineTemplate < ActiveRecord::Base
  # Accessible
  attr_accessible :title, :description
  # Associations
  belongs_to :user
end
