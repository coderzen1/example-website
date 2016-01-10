# Custom object for multistep registration form
class RestaurantInfo < ActiveType::Object
  attribute :restaurant_name, :string
  attribute :owner_name, :string
  attribute :owner_birth, :date
  attribute :user

  validates :restaurant_name, presence: true
  validates :owner_name, presence: true
  validates :owner_birth, presence: true

  def save
    return false if invalid?

    persist_data

    true
  end

  private

  def persist_data
    restaurant.assign_attributes(
      name: restaurant_name
    )

    restaurant.save(validate: false)

    user.update(name: owner_name, birthday: owner_birth, restaurant: restaurant,
                registration_status: :owner_additional_info)
  end

  def restaurant
    @restaurant ||= Restaurant.new
  end
end
