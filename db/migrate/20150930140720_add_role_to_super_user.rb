class AddRoleToSuperUser < ActiveRecord::Migration
  def change
    add_column :super_users, :role, :integer
  end
end
