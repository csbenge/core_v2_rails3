class ChangeDepTypEtoInteger < ActiveRecord::Migration
  def up
    change_column :depots, :dep_type, :integer
  end

  def down
  end
end
