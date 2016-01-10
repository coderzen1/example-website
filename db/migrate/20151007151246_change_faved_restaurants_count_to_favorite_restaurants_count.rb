class ChangeFavedRestaurantsCountToFavoriteRestaurantsCount < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :faved_restaurants_count, :favorite_restaurants_count
    end
  end
end
