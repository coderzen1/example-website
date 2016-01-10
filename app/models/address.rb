class Address < ActiveRecord::Base
  # TODO: Fix validations
  # validates :country, presence: true

  has_one :restaurant
  has_one :restaurant_owner

  def to_api_format
    if united_states?
      [address, city, us_state_format, country].compact.join(', ')
    else
      [address, world_city_format, country].compact.join(', ')
    end
  end

  private

  def united_states?
    country == "United States"
  end

  def world_city_format
    [zip_code, city].compact.join(' ')
  end

  def us_state_format
    [state, zip_code].compact.join(' ')
  end
end
