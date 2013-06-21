# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  name        :string(255)      not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base
  # Accessible
  attr_accessible :name, :description
  # Associations
  belongs_to :user
  has_many :designs, :dependent => :nullify
end
