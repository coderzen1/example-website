class RestaurantFiller

  def initialize(lat:, lng:, radius:)
    @lat = lat
    @lng = lng
    @radius = radius.to_i
  end

  def call
    return if area_covered?
    fill_restaurants
    log_request
  end

  private

  attr_reader :lat, :lng, :radius

  def restaurants_data
    @restaurants_data ||= FoodFave::Foursquare::RestaurantEndpoint.nearby_search(lat: lat, lng: lng, radius: radius)
  end

  def fill_restaurants
    @restaurants ||= restaurants_data.map do |restaurant_data|
      FoodFave::Foursquare::RestaurantFactory.new(restaurant_data, restaurants_request_id: log_request.id).find_or_create
    end
  end

  def log_request
    @log_request ||= RestaurantsRequest.create!(lat: lat, lng: lng, radius: radius)
  end

  def area_covered?
    RestaurantsRequest.where(*area_covered_sql_array).any?
  end

  def area_covered_sql_array
    ['earth_distance(ll_to_earth(?, ?), ll_to_earth(restaurants_requests.lat, restaurants_requests.lng)) < 20 AND @(restaurants_requests.radius - ?) < 10',
      lat, lng, radius]
  end
end
