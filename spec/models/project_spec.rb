# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  name        :string(255)      not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Project do
  it "should access to attributes: name and description"

  describe "validate" do

    describe "user_id" do
      it "should be required"
    end

    describe "name" do
      it "should be required"
    end
  end
end
