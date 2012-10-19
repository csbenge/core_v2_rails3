class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :sch_name
      t.string :sch_cronspec
      t.integer :sch_status
      t.integer :sch_user
      t.string :sch_action

      t.timestamps
    end
  end
end
