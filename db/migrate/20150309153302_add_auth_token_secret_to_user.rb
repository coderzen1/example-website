class AddAuthTokenSecretToUser < ActiveRecord::Migration
  def change
    add_column :users, :auth_token_secret, :string
  end
end
