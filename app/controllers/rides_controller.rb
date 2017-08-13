class RidesController < ApplicationController

  before_action :find_or_create_customer, only: [ :create ]
  before_action :check_if_rides_available, only: [ :create ]

  def index
    #TODO - Pagination
    @rides = Ride.fetch_all_rides
  end

  def new
  end

  def create
    begin
      ride = @customer.rides.create( status: "waiting", request_time: Time.now )

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

  def find_or_create_customer
    if params[:sys_id].present?
      @customer = Customer.find_or_create_by( sys_id: params[:sys_id] )
    else
      render :json => { :success => false, :user_message => "Please enter customer id", :status => 400 } 
    end
  end

  def check_if_rides_available
    #allow rides only if there are less than 10 waiting rides
    render :json => { :success => false, :user_message => "Rides not available. Please try again later", :status => 200 } if Ride.waiting.count >= 10
  end

end
