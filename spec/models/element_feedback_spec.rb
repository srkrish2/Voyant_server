# == Schema Information
#
# Table name: element_feedbacks
#
#  id               :integer          not null, primary key
#  design_id        :integer          not null
#  configuration_id :integer          not null
#  name             :string(255)      not null
#  vote             :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe ElementFeedback do
  describe "validate" do

    describe "design" do
      it "should be required"
    end

    describe "configuration" do
      it "should be required"
    end

    describe "name" do
      it "should be required"
      it "should be unique"
    end
  end
end
