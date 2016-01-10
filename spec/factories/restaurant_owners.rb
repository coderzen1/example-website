FactoryGirl.define do
  factory :restaurant_owner do
    sequence(:email) { |n| "user#{n}@email.com" }
    password "asdsadasdasdasds"
    name "Filip Kuster"
    birthday "23.12.1991"
    registration_status RestaurantOwner.registration_statuses[:finished]
    restaurant
  end
end
