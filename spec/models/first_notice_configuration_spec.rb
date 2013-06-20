# == Schema Information
#
# Table name: first_notice_configurations
#
#  id           :integer          not null, primary key
#  design_id    :integer          not null
#  is_required  :boolean          default(TRUE)
#  turker_num   :integer          default(0)
#  turker_price :float            default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe FirstNoticeConfiguration do

  describe "validate" do
    describe "design" do
      it "should be required"
    end
    
  end

end
