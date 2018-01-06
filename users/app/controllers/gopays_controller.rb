class GopaysController < ApplicationController
  before_action :set_gopay, except: [:index, :new, :create]

  def index
    @gopays = Gopay.all
  end

  def show
  end

  def topup
  end

  def do_topup
    response = @gopay.gopay.topup(params[:amount])

    respond_to do |format|
      if @gopay.save && response
        format.html { redirect_to topup_gopay_path, notice: 'Top up success.' }
      else
        format.html { redirect_to topup_gopay_path, notice: 'Top up failed: Amount is invalid.' }
      end
    end
  end

  private

    def set_gopay
      @gopay = Gopay.find(params[:id])
    end

    def gopay_params
      params.require(:gopay).permit(:balance, :ref_type, :ref_id)
    end
end
