class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :sys_id

      t.timestamps
    end
    add_index :drivers, :sys_id, :unique => true
  end
end
