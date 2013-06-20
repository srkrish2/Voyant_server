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
  # attr_accessible :title, :body
end
