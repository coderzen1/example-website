FactoryGirl.define do
  factory :address do
    address 'Jarnoviceva 7'
    zip_code '10000'
    city 'Zagreb'
    state 'Hrvatska'
    country 'Hrvatska'

    factory :lateral_address do
      address 'Strojarska 22'
    end

    factory :umami_address do
      address 'Horvacanska 75'
    end
  end
end
