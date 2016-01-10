class AddRegistrationStatusToRestaurantOwner < ActiveRecord::Migration
  def change
    add_column :restaurant_owners, :registration_status, :integer, default: 0
  end
end
