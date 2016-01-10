class EnableEarthdistanceExtension < ActiveRecord::Migration
  def change
    enable_extension :earthdistance
  end
end
