class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize, :set_gopay

  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to home_path, notice: 'Please Login'
      end
    end

    def set_gopay
      Gopay.all.each do |gopay|
        @gopay = gopay if gopay.ref_type == "User" && gopay.ref_id == session[:user_id]
      end
    end
end
