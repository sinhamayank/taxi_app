class Ride < ActiveRecord::Base
  belongs_to :customer
  belongs_to :driver

  scope :waiting, -> { where(status: 'waiting') } #ideally the way status should be stored should be with some agreed convention

  def self.fetch_waiting_and_driver_rides( driver_id )
    Ride.select("id, customer_id, request_time, pickup_time, status").where("driver_id IS NULL OR driver_id = ?", driver_id).includes(:customer).group_by(&:status)
  end

end
