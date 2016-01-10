task strojarska_restaurants: :environment do
  my_lat = 45.8007988
  my_lng = 15.9906049
  radius = 400

  # 45.8007988,15.9906049

  restaurants_data = FoodFave::Foursquare::RestaurantEndpoint.nearby_search(lat: my_lat, lng: my_lng, radius: radius)

  restaurants_data.map do |restaurant_data|
    FoodFave::Foursquare::RestaurantFactory.new(restaurant_data).find_or_create
  end
end
