class MigrateRestaurantAddresses < ActiveRecord::Migration
  class Address < ActiveRecord::Base
    validates :country, presence: true

    has_one :restaurant

    def to_api_format
      if united_states?
        [address, city, [state, zip_code].compact.join(' '), country].compact.reject(&:blank?).join(', ')
      else
        [address, [zip_code, city].compact.join(' '), country].compact.reject(&:blank?).join(', ')
      end
    end

    private

    def united_states?
      country == "United States"
    end
  end

  class Restaurant < ActiveRecord::Base
    belongs_to :address_model, class_name: Address, foreign_key: :address_id

    validates :address_model, presence: true
  end

  def up
    ActiveRecord::Base.transaction do
      Restaurant.where.not(address: nil).find_each do |restaurant|
        address_model = Address.create!(
          address: restaurant_address(restaurant),
          country: restaurant_country(restaurant)
        )

        restaurant.address_model = address_model

        restaurant.save
      end
    end
  end

  def down
    ActiveRecord::Base.transaction do
      Address.find_each do |address|
        restaurant = address.restaurant

        restaurant.address = address.to_api_format

        restaurant.save
      end
    end
  end

  def restaurant_country(restaurant)
    restaurant.address.split(', ').last
  end

  def restaurant_address(restaurant)
    restaurant.address.split(', ')[0..-2].compact.join(', ')
  end
end
