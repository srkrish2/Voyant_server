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
  # attr_accessible :title, :body
end
