# == Schema Information
#
# Table name: guideline_templates
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  title       :string(255)      not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe GuidelineTemplate do
  describe "validate" do
    describe "user" do
      it "should be required"
    end

    describe "title" do
      it "should be required"
    end
  end
end
