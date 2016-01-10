class RestaurantPositions
  include ActiveModel::Validations

  validates_presence_of :lat, :lng, :radius
  validates_numericality_of :lat, :lng, :radius

  LIMIT = 30

  def initialize(params = {})
    @lat    = params[:lat]
    @lng    = params[:lng]
    @radius = params[:radius]
  end

  def call
    fail(RocketPants::InvalidResource, errors) if invalid?

    prefill_data_if_needed

    Restaurant
      .select(:id, :name, :lat, :lng)
      .where(*where_in_radius_expression)
      .limit(LIMIT)
  end

  private

  attr_reader :lat, :lng, :radius

  def where_in_radius_expression
    ["earth_box(ll_to_earth(?, ?), ?) @> ll_to_earth(restaurants.lat, restaurants.lng)", lat, lng, radius]
  end

  def prefill_data_if_needed
    RestaurantFiller.new(lat: lat, lng: lng, radius: radius).call
  end
end
