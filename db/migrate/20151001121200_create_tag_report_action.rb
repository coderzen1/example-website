class CreateTagReportAction < ActiveRecord::Migration
  def change
    create_table :tag_report_actions do |t|
      t.integer :photo_id
      t.integer :tag_report_id
      t.string  :tag_suggestion
      t.integer :action
      t.timestamps null: false
    end
  end
end
