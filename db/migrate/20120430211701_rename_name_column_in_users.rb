class RenameNameColumnInUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.rename :name, :user_id
    end
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
  end

  def down
  end
end
