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

require 'spec_helper'

describe ImpressionFeedback do
  describe "validate" do
    describe "design" do
      it "should be required"
    end

    describe "name" do
      it "should be required"
    end
  end
end
