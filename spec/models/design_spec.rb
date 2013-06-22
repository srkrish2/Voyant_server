# == Schema Information
#
# Table name: designs
#
#  id                   :integer          not null, primary key
#  project_id           :integer
#  user_id              :integer          not null
#  name                 :string(255)      not null
#  description          :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  is_published         :boolean          default(FALSE)
#

require 'spec_helper'

describe Design do
  describe "validate" do

    describe "user" do
      it "should be required"
    end

    describe "project" do

    end

    describe "name" do
      it "should be required"
    end

    describe "description" do

    end

  end
end
