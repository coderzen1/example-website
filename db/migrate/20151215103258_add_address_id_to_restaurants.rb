class AddAddressIdToRestaurants < ActiveRecord::Migration
  def change
    change_table :restaurants do |t|
      t.belongs_to :address
    end
  end
end
