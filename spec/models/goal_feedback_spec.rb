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
#  code             :string(255)
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

  describe "associations" do
    it "should have many boxareas" do
      goal_feedback = GoalFeedback.new
      expect{goal_feedback.boxarea}.not_to raise_error
    end
  end
end
