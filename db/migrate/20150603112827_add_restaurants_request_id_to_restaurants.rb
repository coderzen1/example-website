class AddRestaurantsRequestIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :restaurants_request_id, :string
  end
end
