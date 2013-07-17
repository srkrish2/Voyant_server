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

require 'spec_helper'

describe SystemFeedbacks do
  pending "add some examples to (or delete) #{__FILE__}"
end
