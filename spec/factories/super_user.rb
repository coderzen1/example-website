FactoryGirl.define do
  factory :super_user do
    sequence :email do |n|
      "test-user-#{n}@example.com"
    end
    password "1111111111"
  end
end
