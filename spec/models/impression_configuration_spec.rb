# == Schema Information
#
# Table name: impression_configurations
#
#  id            :integer          not null, primary key
#  design_id     :integer          not null
#  is_required   :boolean          default(TRUE)
#  turker_num1   :integer          default(0)
#  turker_price1 :float            default(0.0)
#  turker_num2   :integer          default(0)
#  turker_price2 :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe ImpressionConfiguration do
  describe "validate" do
    describe "design" do
      it "shoule be required"
    end
  end
end
