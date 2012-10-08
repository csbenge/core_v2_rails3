class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.string :type
      t.string :version
      t.references :depot

      t.timestamps
    end
    add_index :packages, :depot_id
  end
end
