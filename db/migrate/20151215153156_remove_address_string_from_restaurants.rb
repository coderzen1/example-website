class RemoveAddressStringFromRestaurants < ActiveRecord::Migration
  def up
    change_table :restaurants do |t|
      t.remove :address
    end
  end

  def down
    change_table :restaurants do |t|
      t.string :address
    end
  end
end
