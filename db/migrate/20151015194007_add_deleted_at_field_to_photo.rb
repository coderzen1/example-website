class AddDeletedAtFieldToPhoto < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.datetime :deleted_at
    end
  end
end
