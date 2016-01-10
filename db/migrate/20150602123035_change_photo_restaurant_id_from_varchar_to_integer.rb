class ChangePhotoRestaurantIdFromVarcharToInteger < ActiveRecord::Migration
  def change
    change_column :photos, :restaurant_id, 'integer USING CAST(restaurant_id AS integer)'
  end
end
