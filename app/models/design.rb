# == Schema Information
#
# Table name: designs
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  user_id     :integer          not null
#  name        :string(255)      not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Design < ActiveRecord::Base
  # Accessible
  attr_accessible :picture, :name, :description
  # Associations
  has_attached_file :picture, :styles => {:medium => "300x300", :thumb => "100x100"}, :default_url => "/images/:style/missing.png"
  belongs_to :user
  belongs_to :project
  has_one :audience_configuration, :dependent => :destroy
  has_many :element_configurations, :dependent => :destroy
  has_one :first_notice_configuration, :dependent => :destroy
  has_one :impression_configuration, :dependent => :destroy
  has_many :goal_configurations, :dependent => :destroy
  has_many :guideline_configurations, :dependent => :destroy
end
