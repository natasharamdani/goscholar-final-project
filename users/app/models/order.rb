class Order < ApplicationRecord
  GMAPS = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')

  belongs_to :user
  belongs_to :service

  enum payment_type: {
    "Cash" => "cash",
    "Go-Pay" => "gopay"
  }

  validates :origin, :destination, :payment_type, :state, presence: true
  validates :payment_type, inclusion: payment_types.keys

  validate :validate_locations

  def get_distance
    distance_matrix = GMAPS.distance_matrix(origin, destination)
    distance = distance_matrix[:rows][0][:elements][0][:distance][:value] / 1000.0
    self.distance = distance.to_f.round(1) if distance > 1
    self.distance
  end

  def calculate_price
    price = service.price_per_km * self.distance
    self.price = price.ceil
    self.price
  end

  private

    def validate_locations
      if origin != "" && destination != ""
        distance_matrix = GMAPS.distance_matrix(origin, destination)
        status = distance_matrix[:rows][0][:elements][0][:status]
        if status == "NOT_FOUND"
          errors.add(:origin, "is invalid")
          errors.add(:destination, "is invalid")
        end
      end
    end
end
