class NearbyPlaces
  include ActiveModel::Validations

  PER_PAGE = 10

  validates_presence_of :lat, :lng
  validates_numericality_of :lat, :lng

  def initialize(params = {})
    @lat         = params[:lat]
    @lng         = params[:lng]
    @page        = params[:page] || 1
    @per_page    = params[:per_page] || PER_PAGE
    @search_term = params[:search_term]
  end

  def call
    fail(RocketPants::InvalidResource, errors) if invalid?

    if search_term.present?
      nearby_places_with_search
    else
      nearby_places_without_search
    end
  end

  def nearby_places_without_search
    Restaurant
      .includes(:address)
      .select(:id, :name, :photo, :address_id, earth_distance_selector)
      .order('distance ASC')
      .page(page)
      .per_page(per_page)
  end

  def nearby_places_with_search
    nearby_places_without_search.where("name ILIKE ?", "%%#{search_term}%%")
  end

  private

  attr_reader :lat, :lng, :page, :per_page, :search_term

  def earth_distance_selector
    ActiveRecord::Base.send(:sanitize_sql_array, earth_distance_selector_array)
  end

  def earth_distance_selector_array
    ["earth_distance(ll_to_earth(?, ?), ll_to_earth(restaurants.lat, restaurants.lng)) as distance", lat, lng]
  end
end
