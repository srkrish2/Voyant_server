# == Schema Information
#
# Table name: first_notice_feedbacks
#
#  id                  :integer          not null, primary key
#  design_id           :integer          not null
#  element_feedback_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe FirstNoticeFeedback do
  describe "validate" do
    describe "design" do
      it "should be required"
    end
    
    describe "element_feedback" do
      it "should be required"
    end
  end

  describe "associations" do
    it "should have many boxareas" do
      first_notice_feedback = FirstNoticeFeedback.new
      expect{first_notice_feedback.boxarea}.not_to raise_error
    end
  end
end
