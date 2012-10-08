class RenameFieldinPackage < ActiveRecord::Migration
  def up
    change_table :packages do |t|
      t.rename :type, :ptype
    end
  end

  def down
  end
end
