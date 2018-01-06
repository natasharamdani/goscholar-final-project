class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]
  before_action :set_gopay
  skip_before_action :authorize, only: [:new, :create]

  def index
    @drivers = Driver.where("id = ?", session[:driver_id])

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @drivers }
    end
  end

  def show
  end

  def new
    @driver = Driver.new
  end

  def edit
  end

  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to login_path, notice: 'Driver was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to driver_path, notice: 'Driver was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def set_gopay
      Gopay.all.each do |gopay|
        @gopay = gopay if gopay.ref_type == "Driver" && gopay.ref_id == session[:user_id]
      end
    end

    def set_driver
      @driver = Driver.find(session[:driver_id])
    end

    def driver_params
      params.require(:driver).permit(:fullname, :phone, :email, :password, :password_confirmation, :service_type)
    end
end
