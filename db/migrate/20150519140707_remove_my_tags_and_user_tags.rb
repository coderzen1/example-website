class RemoveMyTagsAndUserTags < ActiveRecord::Migration
  def change
    drop_table :user_tags
    drop_table :tags
  end
end
