# == Schema Information
#
# Table name: feedback_codes
#
#  id            :integer          not null, primary key
#  code          :string(255)      not null
#  feedback_type :string(255)      not null
#  feedback_id   :integer          not null
#  design_id     :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe FeedbackCode do
  pending "add some examples to (or delete) #{__FILE__}"
end
