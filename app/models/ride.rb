class Ride < ActiveRecord::Base
  belongs_to :customer
  belongs_to :driver

  scope :waiting, -> { where(status: 'waiting') } #ideally the way status should be stored should be with some agreed convention
end
