class AddDefaultToOwners < ActiveRecord::Migration
  def change
    change_column_null :restaurant_owners, :birthday, true
    change_column_null :restaurant_owners, :restaurant_id, true
    change_column_null :restaurant_owners, :name, true
  end
end
