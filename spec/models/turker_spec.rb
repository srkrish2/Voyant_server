# == Schema Information
#
# Table name: turkers
#
#  id                :integer          not null, primary key
#  age               :integer          not null
#  gender            :integer          default(0)
#  country           :string(255)      not null
#  design_experience :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe Turker do
  describe "validate" do
    before(:each) do
      @attr = FactoryGirl.attributes_for(:turker)
    end

    describe "age" do
      it "should be required" do
        turker = Turker.new(@attr)
        turker.age = ""
        turker.should_not be_valid
      end
      it "should greater than 0" do
        turker = Turker.new(@attr)
        turker.age = 0 
        turker.should_not be_valid
      end
    end

    describe "gender" do
      it "should in ange [0,1]" do
        turker = Turker.new(@attr)
        turker.gender = 2
        turker.should_not be_valid
        turker.gender = -1
        turker.should_not be_valid
      end
    end

    describe "country" do
      it "should be required" do
        turker = Turker.new(@attr)
        turker.country = ""
        turker.should_not be_valid
      end
    end

    describe "design_experience" do
      it "should be in range [0,1,2]" do
        turker = Turker.new(@attr)
        turker.design_experience = -1
        turker.should_not be_valid
        turker.design_experience = 3
        turker.should_not be_valid
      end
    end

  end

  #it "should access its attributes: age, gender, country, and design_experience"
  describe "associations" do
    it "should have many boxares" do
      turker = FactoryGirl.build(:turker)
      expect {turker.boxareas}.to_not raise_error
    end
  end
end
