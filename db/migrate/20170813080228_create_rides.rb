class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.datetime :request_time
      t.datetime :pickup_time
      t.integer :customer_id
      t.integer :driver_id

      t.timestamps
    end
  end
end
