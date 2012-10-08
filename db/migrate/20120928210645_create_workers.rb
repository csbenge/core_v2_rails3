class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :wrk_name
      t.string :wrk_description
      t.string :wrk_type
      t.string :wrk_host
      t.integer :wrk_port
      t.string :wrk_user
      t.string :wrk_hashed_password

      t.timestamps
    end
  end
end
