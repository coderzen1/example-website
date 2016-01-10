class AddRestaurantIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :restaurant_id, :string
  end
end
