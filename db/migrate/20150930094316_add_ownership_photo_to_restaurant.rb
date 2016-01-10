class AddOwnershipPhotoToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :ownership_document, :string
  end
end
