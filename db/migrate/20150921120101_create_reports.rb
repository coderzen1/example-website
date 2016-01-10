class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :photo_id
      t.integer :reporter_id
      t.string :reporter_type
      t.timestamps null: false
    end
  end
end
