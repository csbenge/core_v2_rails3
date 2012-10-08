class RefactorDepotTable < ActiveRecord::Migration
  def up
    change_table :depots do |t|
      t.rename :name, :dep_name
      t.rename :description, :dep_desc
      t.rename :status, :dep_status
    end
    add_column :depots, :dep_type, :string
    add_column :depots, :dep_url, :string
  end

  def down
  end
end
