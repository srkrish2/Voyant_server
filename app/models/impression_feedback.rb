# == Schema Information
#
# Table name: impression_feedbacks
#
#  id         :integer          not null, primary key
#  design_id  :integer          not null
#  name       :string(255)      not null
#  vote       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImpressionFeedback < ActiveRecord::Base
  # Accessible
  attr_accessible :name
  # Association
  has_many :boxareas, :as => :feedback
end
