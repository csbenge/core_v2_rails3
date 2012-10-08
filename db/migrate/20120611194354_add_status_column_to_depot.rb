class AddStatusColumnToDepot < ActiveRecord::Migration
  def change
     add_column :depots, :status, :integer
  end
end
