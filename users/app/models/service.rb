class Service < ApplicationRecord
  has_many :orders

  validates :service_type, :price_per_km, presence: true
  validates :price_per_km, numericality: true
end
