class CreateRestaurantsRequests < ActiveRecord::Migration
  def change
    create_table :restaurants_requests do |t|
      t.float :lat
      t.float :lng
      t.integer :radius

      t.timestamps null: false
    end
  end
end
