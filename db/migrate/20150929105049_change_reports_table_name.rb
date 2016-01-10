class ChangeReportsTableName < ActiveRecord::Migration
  def change
    rename_table :reports, :photo_reports
  end
end
