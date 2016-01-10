class CreateTagReports < ActiveRecord::Migration
  def change
    create_table :tag_reports do |t|
      t.integer :tag_id
      t.integer :reporter_id
      t.string :reporter_type
      t.timestamps null: false
    end
  end
end
