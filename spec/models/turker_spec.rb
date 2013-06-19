require 'spec_helper'

describe Turker do
  describe "validate" do

    describe "age" do
      it "should be required"
      it "should greater than 0"
    end

    describe "gender" do
      it "should in ange [0,1]"
    end

    describe "country" do
      it "should be required"
    end

    describe "design_experience" do
      it "should be in range [0,1,2]"
    end

  end

  it "should access its attributes: age, gender, country, and design_experience"
end
