class AddFieldsToArtifact < ActiveRecord::Migration
  def change
    add_column :artifacts, :aname, :string
    add_column :artifacts, :upload_url, :string
  end
end
