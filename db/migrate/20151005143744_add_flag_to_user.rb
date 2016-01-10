class AddFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :flagged_user, :integer, default: 0
  end
end
