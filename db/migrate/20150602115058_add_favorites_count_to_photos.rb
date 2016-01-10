class AddFavoritesCountToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :favorites_count, :integer
  end
end
