class DriversController < ApplicationController

  before_action :fetch_driver
  before_action :check_if_ongoing_ride_present, only: [ :accept_ride ]

  def home
    @rides = Ride.fetch_waiting_and_driver_rides( @driver.id ) if @driver.present?
  end

  def accept_ride
    begin
      if !@cant_accept
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
    if @driver.blank?
      @cant_accept = true
      flash[:error] = "Please give correct driver's id"
    end
  end

  def check_if_ongoing_ride_present
    if ( @driver.present? and @driver.rides.ongoing.count > 0 )
      @cant_accept = true
      flash[:notice] = "Please complete your ongoing ride before accepting"
    end
  end

end
