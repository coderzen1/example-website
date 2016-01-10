class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name

      t.string :provider
      t.string :uid
      t.string :auth_token
      t.string :provider_profile_picture

      t.string :custom_profile_picture

      t.string :location

      t.integer :radius # Always in km

      t.boolean :private_faved_photos
    end
  end
end
