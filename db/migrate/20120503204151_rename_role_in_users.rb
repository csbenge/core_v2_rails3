class RenameRoleInUsers < ActiveRecord::Migration
  def up
    
    change_table :users do |t|
      t.rename :role, :role_id
    end
  end

  def down
  end
end
