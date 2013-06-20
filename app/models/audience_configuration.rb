# == Schema Information
#
# Table name: audience_configurations
#
#  id                :integer          not null, primary key
#  design_id         :integer          not null
#  gender            :string(255)      not null
#  age               :string(255)      not null
#  country           :string(255)      not null
#  design_experience :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class AudienceConfiguration < ActiveRecord::Base
  # attr_accessible :title, :body
end
