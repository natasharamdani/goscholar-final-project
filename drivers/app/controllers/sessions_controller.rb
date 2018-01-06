class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
    if session[:driver_id]
      redirect_to drivers_path
    end
  end

  def create
    driver = Driver.find_by(phone: params[:phone])

    if driver.try(:authenticate, params[:password])
      session[:driver_id] = driver.id
      redirect_to drivers_path
    else
      redirect_to login_path, notice: 'Invalid phone/password combination'
    end
  end

  def destroy
    session[:driver_id] = nil
    redirect_to home_path, notice: 'Logged out'
  end
end
