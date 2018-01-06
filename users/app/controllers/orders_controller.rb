class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :cancel]
  skip_before_action :authorize, only: :index

  def index
    @orders = Order.where("user_id = ?", session[:user_id])
    @all_orders = Order.all

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @all_orders, only: order_data + [:driver_id] }
    end
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = User.find(session[:user_id])

    @order.distance = @order.get_distance
    @order.price = @order.calculate_price

    respond_to do |format|
      if @order.save
        $rdkafka_producer.produce(payload: @order.to_json, topic: $topic)
        format.html { redirect_to orders_path, notice: 'Thank you for your order.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @order.update(order_params)
  end

  def cancel
    @order.state = "Cancelled"
    @order.save
    redirect_to order_path
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(order_data + [:service_id])
    end

    def order_data
      [:origin, :destination, :payment_type, :distance, :price]
    end
end
