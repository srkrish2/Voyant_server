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

  attr_accessible :picture
  
  has_attached_file :picture, :styles => {:medium => "300x300", :thumb => "100x100"}, :default_url => "images/:style/missing.png"
end
