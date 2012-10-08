class RefactorArtifactTable < ActiveRecord::Migration
  def up
    change_table :artifacts do |t|
      t.rename :name, :art_name
      t.rename :description, :art_desc
      t.rename :atype, :art_type
      t.rename :version, :art_version
      t.rename :upload_url, :art_url
    end
    change_column :artifacts, :art_type, :integer
    remove_column :artifacts, :aname
  end

  def down
  end
end
