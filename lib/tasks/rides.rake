namespace :rides do

  desc "update ongoing rides to complete if 5 minutes have elapsed from the pickup time"
  task :update => :environment do
    Ride.where("status = ? and pickup_time <= ?", "ongoing", Time.now - 5.minutes).update_all(status: "complete")
  end

end