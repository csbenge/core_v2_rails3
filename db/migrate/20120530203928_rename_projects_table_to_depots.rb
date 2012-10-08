class RenameProjectsTableToDepots < ActiveRecord::Migration
  def up
    rename_table :projects, :depots
  end

  def down
  end
end
