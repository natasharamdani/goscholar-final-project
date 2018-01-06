class FleetsController < ActionController::API
  before_action :set_fleet, except: [:index, :create]

  def index
    @fleets = Fleet.all

    render json: @fleets, only: [:id, :driver_id] + fleet_data
  end

  def show
    render json: @fleet
  end

  def new
    @fleet = Fleet.new
  end

  def edit
  end

  def create
    @fleet = Fleet.new(fleet_params)
  end

  def update
  end

  private

    def set_fleet
      @fleet = Fleet.find(params[:id])
    end

    def fleet_params
      params.permit(fleet_data)
    end

    def fleet_data
      [:driver_name, :service_id, :location]
    end
end
