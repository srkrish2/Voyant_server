# == Schema Information
#
# Table name: element_feedbacks
#
#  id               :integer          not null, primary key
#  design_id        :integer          not null
#  configuration_id :integer          not null
#  name             :string(255)      not null
#  vote             :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ElementFeedback < ActiveRecord::Base
  # Accessible
  attr_accessible :name
  # Validations
  # Associations
  has_many :boxareas, :as => :feedback, :dependent => :destroy
end
