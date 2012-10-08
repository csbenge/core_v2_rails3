class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :eng_name
      t.string :eng_description
      t.string :eng_type
      t.string :eng_host
      t.integer :eng_threads

      t.timestamps
    end
  end
end
