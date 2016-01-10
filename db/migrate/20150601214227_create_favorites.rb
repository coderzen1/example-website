class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :faved_id
      t.string :faved_type

      t.timestamps null: false
    end
  end
end
