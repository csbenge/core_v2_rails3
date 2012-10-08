class RenameUserIDtoName < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.rename :userid, :name
    end
  end

  def down
  end
end
