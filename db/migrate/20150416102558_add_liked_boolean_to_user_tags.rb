class AddLikedBooleanToUserTags < ActiveRecord::Migration
  def change
    add_column :user_tags, :liked, :boolean, default: true
  end
end
