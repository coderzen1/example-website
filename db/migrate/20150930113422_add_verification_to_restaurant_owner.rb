class AddVerificationToRestaurantOwner < ActiveRecord::Migration
  def change
    add_column :restaurant_owners, :ownership_verification_status, :integer, default: 0
  end
end
