# == Schema Information
#
# Table name: system_feedbacks
#
#  id         :integer          not null, primary key
#  user_type  :string(255)
#  user_id    :integer
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SystemFeedbacks < ActiveRecord::Base
  # Accessible
  attr_accessible :comment
  # Associations
  belongs_to :user, :polymorphic => true


end
