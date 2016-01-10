class DiscoverScreenService
  include ActiveModel::Validations

  PER_PAGE = 10

  RADIUS_IN_METERS = 20_000

  GRAVITY = 1.8

  validates_presence_of :lat, :lng
  validates_numericality_of :lat, :lng

  def initialize(params = {})
    @lat         = params[:lat]
    @lng         = params[:lng]
    @page        = params[:page] || 1
    @per_page    = params[:per_page] || PER_PAGE
  end

  def call
    fail(RocketPants::InvalidResource, errors) if invalid?

    Photo
      .approved
      .not_deleted
      .joins(:restaurant)
      .select(:id, :image, :restaurant_id,
              :favorites_count,
              'restaurants.name AS restaurant_name',
              rating_select_clause)
      .order('rating DESC')
      .paginate(page: page, per_page: per_page)
      # .where(where_in_radius_expression)
  end

  private

  attr_reader :lat, :lng, :page, :per_page

  def rating_select_clause
    "round(((photos.favorites_count - 1) / pow((round(EXTRACT(EPOCH FROM (now() - photos.created_at)) / 3600) + 2), #{GRAVITY}) :: numeric), 10) as rating"
  end

  def where_in_radius_expression
    ["earth_box(ll_to_earth(?, ?), ?) @> ll_to_earth(restaurants.lat, restaurants.lng)", lat, lng, RADIUS_IN_METERS]
  end
end

# SELECT photos.id, photos.image, restaurants.name AS restaurant_name, restaurants.id AS restaurant_id, (photos.favorites_count - 1) / pow((round(EXTRACT(EPOCH FROM (now() - photos.created_at)) / 3600) + 2), 1.8) as rating FROM photos JOIN restaurants ON restaurants.id = photos.restaurant_id ORDER BY rating DESC
# SELECT photos.id, photos.favorites_count, restaurants.name, (photos.favorites_count - 1) / pow((round(EXTRACT(EPOCH FROM (now() - photos.created_at)) / 3600) + 2), 1.8) as rating, photos.created_at FROM photos JOIN restaurants ON restaurants.id = photos.restaurant_id ORDER BY rating DESC
