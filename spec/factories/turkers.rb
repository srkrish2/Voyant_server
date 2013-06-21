# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :turker do
    age {rand(1..100)}
    gender {rand(0..1)}
    country {["USA", "China", "Japan"][rand(0..2)]}
    design_experience {rand(0..2)}
  end
end
