FactoryGirl.define do
  factory :restaurant do
    name Faker::Company.name
    foursquare_id { SecureRandom.hex(4) }
    lat Faker::Address.latitude
    lng Faker::Address.longitude
    photo Faker::Avatar.image('500x500')
    phone_number Faker::PhoneNumber.phone_number
    website Faker::Internet.url
    email Faker::Internet.free_email

    address

    factory :lateral, class: Restaurant do
      name 'Lateral'
      foursquare_id '3sda43er8'
      lat 45.8039401
      lng 15.9895105
      initialize_with { Restaurant.where(foursquare_id: '3sda43er8').first_or_create }

      association :address, factory: :lateral_address
    end

    factory :umami, class: Restaurant do
      name 'Umami'
      foursquare_id 'dfh71ry433'
      lat 45.8141409
      lng 15.9757991
      initialize_with { Restaurant.where(foursquare_id: 'dfh71ry433').first_or_create }

      association :address, factory: :umami_address
    end
  end
end
