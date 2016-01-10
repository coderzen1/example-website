FactoryGirl.define do
  factory :photo do
    association :owner, factory: :user
    association :restaurant, factory: :lateral
    caption "Hello from France!"
    image Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'chicken-meal.jpg'))
  end
end
