# == Schema Information
#
# Table name: goal_configurations
#
#  id            :integer          not null, primary key
#  design_id     :integer          not null
#  title         :string(255)      not null
#  description   :text
#  is_required   :boolean          default(TRUE)
#  turker_num    :integer          default(0)
#  turker_price  :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feedbacks_num :integer          default(20)
#

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
