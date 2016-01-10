FactoryGirl.define do
  factory :user do
    username "Test user"
    password "password1"
    password_confirmation "password1"
    location "Zagreb, Croatia"
    custom_profile_picture "http://placehold.it/300x300"

    sequence :email do |n|
      "test-user-#{n}@example.com"
    end

    factory :user_with_followers_and_following do
      transient do
        number_of_followers 5
        number_of_following 5
      end

      after(:create) do |user, evaluator|
        user.followers << create_list(:user, evaluator.number_of_followers)
        user.following << create_list(:user, evaluator.number_of_following)
      end
    end

    factory :user_with_following_restaurants do
      transient do
        number_of_restaurants 5
      end

      after(:create) do |user, evaluator|
        user.favorite_restaurants << create_list(
          :restaurant,
          evaluator.number_of_restaurants
        )
      end
    end

    factory :user_with_favorited_photos_and_tags do
      transient do
        number_of_photos 5
        number_of_tags 5
      end

      after(:create) do |user, evaluator|
        user.favorite_photos << create_list(:photo, evaluator.number_of_photos)
        user.favorite_tags << create_list(:tag, evaluator.number_of_tags)
      end
    end

    factory :user_with_favorited_photos do
      transient do
        number_of_photos 5
      end

      after(:create) do |user, evaluator|
        user.favorite_photos << create_list(:photo, evaluator.number_of_photos)
      end
    end

    factory :user_with_favorited_photos_and_restaurants do
      transient do
        number_of_photos 5
        number_of_restaurants 5
      end

      after(:create) do |user, evaluator|
        user.favorite_photos << create_list(:photo, evaluator.number_of_photos)
        user.favorite_restaurants << create_list(
          :restaurant,
          evaluator.number_of_restaurants
        )
      end
    end

    trait :user_with_provider do
      password nil
      password_confirmation nil
    end

    factory :facebook_user, traits: [:facebook]
    factory :twitter_user, traits: [:twitter]

    trait :facebook do
      user_with_provider

      provider "facebook"
      auth_token "3b930b4f71d2db53de52"
      uid "1384763815174614"
      custom_profile_picture nil
      provider_profile_picture "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c15.0.50.50/p50x50/10354686_10150004552801856_220367501106153455_n.jpg?oh=d228993efabaa22da72afab02b5ac521&oe=55D2C32F&__gda__=1440183769_642063dd9d20661edb3c8d2362acfc74"
    end

    trait :twitter do
      user_with_provider

      email ""
      provider "twitter"
      uid "1234567890"
      auth_token "duf8jf9s1BmJ3Jw84OpEK06Iu"
      auth_token_secret "aYrs1UihxSLQdsobFio8JITRUffcntlDkuYAmzNax9h2bROn4z"
      custom_profile_picture nil
      provider_profile_picture "http://a0.twimg.com/sticky/default_profile_images/default_profile_6_normal.png"
    end
  end
end
