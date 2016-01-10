FactoryGirl.define do
  factory :twitter_user_instance, class: Twitter::User do
    skip_create

    id 1_234_567_890
    name "Test name"
    screen_name "Test_User"
    location "Zagreb, Croatia"
    profile_image_uri Addressable::URI.parse("http://abs.twimg.com/sticky/default_profile_images/default_profile_3_normal.png")

    initialize_with { new(attributes) }
  end
end
