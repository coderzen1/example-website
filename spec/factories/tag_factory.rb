FactoryGirl.define do
  factory :tag, class: ActsAsTaggableOn::Tag do
    sequence :name do |n|
      "tag-#{n}"
    end
  end
end
