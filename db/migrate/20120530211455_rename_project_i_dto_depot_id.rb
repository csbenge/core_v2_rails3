class RenameProjectIDtoDepotId < ActiveRecord::Migration
  def up
    rename_column :credentials, :project_id, :depot_id
  end

  def down
  end
end
