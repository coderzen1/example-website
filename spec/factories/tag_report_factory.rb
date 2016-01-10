FactoryGirl.define do
  factory :tag_report do
    association :reporter, factory: :restaurant_owner
    tag
  end
end
