require 'spec_helper'

describe GoalConfiguration do
  describe "validate" do

    describe "design" do
      it "should be required"
    end

    describe "title" do
      it "should be required"
    end

    describe "turker_num" do
      it "should no lower than 0"
    end

    describe "turker_price" do
      it "should no lower than 0"
    end

  end
end
