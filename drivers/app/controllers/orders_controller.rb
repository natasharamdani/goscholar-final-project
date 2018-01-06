class OrdersController < ApplicationController
  before_action :set_order, only: :show

  def index
    @orders = Order.all
  end

  def show
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:origin, :destination, :payment_type, :service_id)
    end
end
