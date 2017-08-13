class DriversController < ApplicationController

  before_action :fetch_driver

  def home
    @rides = Ride.fetch_waiting_and_driver_rides( @driver.id ) if @driver.present?
  end

  def accept_ride
    begin
      if @driver.present?
        ride = Ride.find_by_id( params[:ride_id] )
        if ride.status == "waiting"
          ride.update_attributes( driver_id: @driver.id, status: "ongoing", pickup_time: Time.now )
          flash[:success] = "Successfully Accepted the Ride!"
        else
          flash[:notice] = "Oops! Some other driver already accepted it"
        end
      end
      redirect_to driver_home_path(id: @driver.id)

    rescue Exception => e
      respond_to do |format|
        logger.error "There was some code error in drivers#accept_ride. " + e.message + " " + Time.zone.now.strftime("%H:%M:%S - %d/%m/%Y").to_s
        flash[:error] = "Please try again later."
        redirect_to driver_home_path(id: @driver.id)
      end      
    end
  end

  def fetch_driver
    @driver = Driver.find_by_sys_id( params[:id] )
    flash[:error] = "Please give correct driver's id" if @driver.blank?
  end

end
