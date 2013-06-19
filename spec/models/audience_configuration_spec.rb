require 'spec_helper'

describe AudienceConfiguration do
  
  describe "validate" do

    describe "design" do
      it "should be required"
    end

    describe "gender" do
      it "should be formated like '0;1;2'"
    end

    describe "age" do
      it "should be formated like 'range1;range2;range3'"
    end

    describe "country" do
      it "should be formated like 'country1;country2;country3'"
    end

    describe "design_experience" do
      it "should be formated like '0;1;2'"
    end

  end


end
