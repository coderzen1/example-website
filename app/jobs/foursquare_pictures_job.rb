class FoursquarePicturesJob < ActiveJob::Base
  queue_as :default

  def perform(restaurant_id)
    @restaurant = Restaurant.find(restaurant_id)

    @restaurant.photo = foursquare_photo

    @restaurant.save
  end

  private

  attr_reader :restaurant

  def foursquare_photo
    first_foursquare_restaurant_photo && first_foursquare_restaurant_photo.link
  end

  def first_foursquare_restaurant_photo
    @restaurant_default_photo ||=
      FoodFave::Foursquare::RestaurantEndpoint.restaurant_photos(
        restaurant_id: restaurant.foursquare_id
      ).first
  end
end
