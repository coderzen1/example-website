class RestaurantLocationInfo < ActiveType::Object
  attribute :user
  attribute :lat, :float
  attribute :lng, :float
  attribute :restaurant

  validates :lat, presence: true
  validates :lng, presence: true
  validates :address, presence: true

  nests_one :address, default: proc { Address.new }

  def save
    return false unless valid? || restaurant.invalid?

    persist_data
  end

  def formatted_coordinates
    if location_present?
      "N" + lat.round(4).to_s + ", W" + lng.round(4).to_s
    else
      "--"
    end
  end

  private

  def persist_data
    address.save!

    restaurant.assign_attributes(address: address, lat: lat, lng: lng)

    return false if restaurant.invalid? || address.invalid?

    restaurant.save

    update_registration_status

    true
  end

  def update_registration_status
    user.registration_status = :finished
    user.save!
  end

  def location_present?
    lat.present? && lng.present?
  end
end
