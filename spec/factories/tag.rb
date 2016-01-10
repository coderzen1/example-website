FactoryGirl.define do
  factory :penne_creamy, class: ActsAsTaggableOn::Tag do
    name 'Penne Creamy Tomato Sauce'
  end

  factory :penne_vodka, class: ActsAsTaggableOn::Tag do
    name 'Penne Alla Vodka'
  end

  factory :gnocchi, class: ActsAsTaggableOn::Tag do
    name 'Gnocchi'
  end
end
