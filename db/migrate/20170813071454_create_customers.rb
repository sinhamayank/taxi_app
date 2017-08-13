class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :sys_id

      t.timestamps
    end

    add_index :customers, :sys_id, :unique => true
  end
end
