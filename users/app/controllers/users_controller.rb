class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  skip_before_action :authorize, only: [:new, :create]
  around_action :rescue_not_found, only: [:do_topup]

  def index
    @users = User.where("id = ?", session[:user_id])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def topup
  end

  def do_topup
    response = topup_gopay(params[:amount])

    respond_to do |format|
      if response
        format.html { redirect_to topup_user_path, notice: 'Top up success.' }
      else
        format.html { redirect_to topup_user_path, notice: 'Top up failed: Amount is invalid.' }
      end
    end
  end

  def topup_gopay(amount)
    if is_valid?(amount)
      @gopay.balance += amount.to_i
      @gopay.save
    else
      false
    end
  end

  def is_valid?(amount)
    if is_integer?(amount) && amount.to_i > 0
      true
    else
      false
    end
  end

  def is_integer?(amount)
    true if Integer(amount) rescue false
  end

  private

    def rescue_not_found
      yield
    rescue ActiveResource::ResourceNotFound
      redirect_to topup_user_path, notice: 'Top up success.'
    end

    def set_user
      @user = User.find(session[:user_id])
    end

    def user_params
      params.require(:user).permit(:fullname, :phone, :email, :password, :password_confirmation)
    end
end
