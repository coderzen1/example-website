require 'rails_helper'

describe RestaurantOwners::TaggedPhotosFilter do
  let(:restaurant) { create(:restaurant) }

  let(:restaurant_owner) do
    create(:restaurant_owner, registration_status: 2, restaurant: restaurant)
  end

  let(:photo1) do
    create(:photo, restaurant: restaurant, owner: restaurant_owner)
  end

  let(:photo2) do
    create(:photo, restaurant: restaurant, owner: restaurant_owner)
  end

  let(:reported_tag) { create(:tag, name: "Awesome") }
  let(:tag) { create(:tag, name: "Funny") }
  let(:tag_report) { create(:tag_report, tag: reported_tag) }

  describe "when filtering photos" do
    it "should delete tag awesome from photo1" do
      photo1.tag_list.add(reported_tag.name, tag.name)
      photo1.save
      photo2.tag_list.add(reported_tag)
      photo2.save

      processed_photos =
        RestaurantOwners::TaggedPhotosFilter
        .new(restaurant, tag_report)
        .process_photos!

      expect(processed_photos.length).to eql(1)
      expect(photo1.reload.tag_list).not_to include("Awesome")
      expect(processed_photos.first.photo_id).to eq(photo2.id)
    end

    it "should return photo1 and photo2" do
      photo1.tag_list.add(reported_tag.name)
      photo1.save
      photo2.tag_list.add(reported_tag.name)
      photo2.save

      processed_photos =
        RestaurantOwners::TaggedPhotosFilter
        .new(restaurant, tag_report)
        .process_photos!

      expect(processed_photos.length).to eql(2)
      expect(processed_photos.collect(&:photo_id))
        .to match_array([photo1.id, photo2.id])
    end

    it "should delete tag from both photos and return []" do
      photo1.tag_list.add(reported_tag.name, tag.name)
      photo1.save
      photo2.tag_list.add(reported_tag.name, tag.name)
      photo2.save

      processed_photos =
        RestaurantOwners::TaggedPhotosFilter
        .new(restaurant, tag_report)
        .process_photos!

      expect(photo1.reload.tag_list).not_to include("Awesome")
      expect(photo2.reload.tag_list).not_to include("Awesome")
      expect(processed_photos).to be_empty
    end
  end
end
