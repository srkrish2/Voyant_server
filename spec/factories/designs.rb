# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :design do
    user
    name "test design"
    picture {fixture_file_upload("../support/images/test.jpg", "image/jpeg")}
  end
end
