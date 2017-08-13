class AddStatusToRide < ActiveRecord::Migration
  def change
    add_column :rides, :status, :string
  end
end
