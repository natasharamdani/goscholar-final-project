class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize

  protected

    def authorize
      unless Driver.find_by(id: session[:driver_id])
        redirect_to home_path, notice: 'Please Login'
      end
    end
end
