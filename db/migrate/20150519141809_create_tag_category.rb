class CreateTagCategory < ActiveRecord::Migration
  def change
    create_table :tag_categories do |t|
      t.string :name
    end
  end
end
