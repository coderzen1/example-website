FactoryGirl.define do
  factory :photo_report do
    photo
    association :reporter, factory: :restaurant_owner
  end
end
