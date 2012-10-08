class CreateUpLoads < ActiveRecord::Migration
  def change
    create_table :up_loads do |t|

      t.timestamps
    end
  end
end
