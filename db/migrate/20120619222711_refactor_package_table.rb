class RefactorPackageTable < ActiveRecord::Migration
  def up
    change_table :packages do |t|
      t.rename :name, :pkg_name
      t.rename :description, :pkg_desc
      t.rename :ptype, :pkg_type
      t.rename :status, :pkg_status
      t.rename :version, :pkg_version
    end
    change_column :packages, :pkg_type, :integer
    add_column :packages, :pkg_url, :string
  end

  def down
  end
end
