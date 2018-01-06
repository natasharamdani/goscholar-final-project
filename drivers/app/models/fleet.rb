class Fleet < ApplicationRecord
  belongs_to :driver

  validates :driver_name, :service_id, presence: true
  validates :location, presence: true, on: :update
end
