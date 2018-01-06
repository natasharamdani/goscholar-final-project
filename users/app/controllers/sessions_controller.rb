class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
    if session[:user_id]
      redirect_to users_path
    end
  end

  def create
    user = User.find_by(phone: params[:phone])

    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to users_path
    else
      redirect_to login_path, notice: 'Invalid phone/password combination'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_path, notice: 'Logged out'
  end
end
