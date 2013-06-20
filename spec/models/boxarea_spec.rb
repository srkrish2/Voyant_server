# == Schema Information
#
# Table name: boxareas
#
#  id             :integer          not null, primary key
#  turker_id      :integer          not null
#  feedback_id    :integer          not null
#  feedback_type  :string(255)      not null
#  top_left_x     :float            not null
#  top_left_y     :float            not null
#  bottom_right_x :float            not null
#  bottom_right_y :float            not null
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Boxarea do
  describe "validate" do

    describe "turker_id" do
      it "should be required"
    end

    describe "feedback_id" do
      it "should be required"
    end

    describe "feedback_type" do
      it "should be required"
    end

    describe "top_left_x" do
      it "should be required"
    end
    
    describe "top_left_y" do
      it "should be required"
    end

    describe "bottom_right_x" do
      it "should be required"
    end

    describe "bottom_right_y" do
      it "should be required"
    end
  end
end
