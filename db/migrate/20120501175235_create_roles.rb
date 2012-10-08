class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.integer :read, :default => 0
      t.integer :write, :default => 0
      t.integer :execute, :default => 0

      t.timestamps
    end
  end
end
