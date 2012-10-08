class CreateArtifacts < ActiveRecord::Migration
  def change
    create_table :artifacts do |t|
      t.string :name
      t.string :description
      t.string :atype
      t.string :version
      t.references :package

      t.timestamps
    end
    add_index :artifacts, :package_id
  end
end
