class RidesController < ApplicationController

  before_action :check_if_sys_id_present, only: [ :create ]
  before_action :check_if_rides_available, only: [ :create ]

  def new
  end

  def create
    begin
      customer = Customer.find_or_create_by( sys_id: params[:sys_id] )
      ride = customer.rides.create( status: "waiting", request_time: Time.now )

      respond_to do |format|
        format.json { render :json => { :success => true, :status => 200 } }
      end
    rescue Exception => e
      respond_to do |format|
        logger.error "There was some code error in rides#create. " + e.message + " " + Time.zone.now.strftime("%H:%M:%S - %d/%m/%Y").to_s
        format.json { render :json => { :success => false, :user_message => "Please try again later.", :status => 500 } }
      end      
    end 
  end

  def check_if_sys_id_present
    render :json => { :success => false, :user_message => "Please enter customer id", :status => 400 } if params[:sys_id].blank?  
  end

  def check_if_rides_available
    #allow rides only if there are less than 10 waiting rides
    render :json => { :success => false, :user_message => "Rides not available. Please try again later", :status => 200 } if Ride.waiting.count >= 10
  end

end
