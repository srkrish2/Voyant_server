# == Schema Information
#
# Table name: goal_feedbacks
#
#  id               :integer          not null, primary key
#  design_id        :integer          not null
#  configuration_id :integer          not null
#  rating           :integer          default(1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe GoalFeedback do
  describe "validate" do
    describe "design" do
      it "should be required"
    end

    describe "configuration" do
      it "should be required"
    end

    describe "rating" do
      it "should be in range 1~7"
    end
  end
end
