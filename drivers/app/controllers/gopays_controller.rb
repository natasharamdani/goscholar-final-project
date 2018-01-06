class GopaysController < ApplicationController
  before_action :set_gopay, except: [:index, :new, :create]

  def index
    @gopays = Gopay.all
  end

  def show
  end

  private

    def set_gopay
      @gopay = Gopay.find(params[:id])
    end

    def gopay_params
      params.require(:gopay).permit(:balance, :ref_type, :ref_id)
    end
end
