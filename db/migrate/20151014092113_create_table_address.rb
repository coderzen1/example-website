class CreateTableAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :country
    end
  end
end
