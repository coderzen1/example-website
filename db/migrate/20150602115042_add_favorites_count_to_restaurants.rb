class AddFavoritesCountToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :favorites_count, :integer
  end
end
