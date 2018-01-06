class DriverObserver < ActiveRecord::Observer
  def after_create(driver)
    case driver.service_type
    when "Go-Ride"
      service_id = 1
    when "Go-Car"
      service_id = 2
    end
    driver.fleet = Fleet.create(driver_name: driver.fullname, service_id: service_id)
    driver.location = driver.fleet.location
    driver.save
  end

  def after_update(driver)
    Fleet.where(driver_id: driver.id).update(driver_name: driver.fullname)
  end
end
