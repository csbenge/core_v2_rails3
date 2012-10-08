class AddStatusColumnToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :status, :integer
  end
end
