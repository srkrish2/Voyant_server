# == Schema Information
#
# Table name: feedback_surveys
#
#  id                  :integer          not null, primary key
#  code                :string(255)      not null
#  feedback_type       :string(255)
#  feedback_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  feedback_controller :string(255)
#  design_id           :integer
#  is_approved         :boolean          default(FALSE)
#

require 'spec_helper'

describe FeedbackSurvey do
  pending "add some examples to (or delete) #{__FILE__}"
end
