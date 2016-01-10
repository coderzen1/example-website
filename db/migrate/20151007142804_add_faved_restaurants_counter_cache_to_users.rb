class AddFavedRestaurantsCounterCacheToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :faved_restaurants_count, default: 0
    end
  end
end
