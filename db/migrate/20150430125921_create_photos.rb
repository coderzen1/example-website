class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.belongs_to :owner, polymorphic: true
      t.string :image
      t.string :caption

      t.timestamps
    end
  end
end
