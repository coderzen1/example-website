class ChangeFlaggedColumnInUser < ActiveRecord::Migration
  def change
    remove_column :users, :flagged_user
    add_column :users, :flagged, :boolean, default: false
  end
end
