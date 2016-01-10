class AddMoreInformationToRestaurants < ActiveRecord::Migration
  def up
    change_table :restaurants do |t|
      t.string :address
      t.string :phone_number
      t.string :email
      t.string :website
    end
  end

  def down
    change_table :restaurants do |t|
      t.remove :address
      t.remove :phone_number
      t.remove :email
      t.remove :website
    end
  end
end
