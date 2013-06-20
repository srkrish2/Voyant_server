# == Schema Information
#
# Table name: audience_configurations
#
#  id                :integer          not null, primary key
#  design_id         :integer          not null
#  gender            :string(255)      not null
#  age               :string(255)      not null
#  country           :string(255)      not null
#  design_experience :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

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
