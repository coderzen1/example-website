class AddColumnsToRestaurantOwner < ActiveRecord::Migration
  def change
    add_column :restaurant_owners, :address_id, :integer
    add_column :restaurant_owners, :phone, :string
    add_column :restaurant_owners, :website, :string
  end
end
