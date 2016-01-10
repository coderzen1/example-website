class AddDefaultToFavoritesCountInPhotos < ActiveRecord::Migration
  def change
    change_column_default :photos, :favorites_count, 0
  end
end
