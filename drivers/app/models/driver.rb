class Driver < ApplicationRecord
  has_secure_password

  after_create :set_gopay

  has_one :fleet
  has_many :orders

  enum service_type: {
    "Go-Ride" => "1",
    "Go-Car" => "2"
  }

  validates :fullname, presence: true
  validates :phone, presence: true, uniqueness: true, numericality: true, length: {minimum: 10, maximum: 13}
  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    message: 'has invalid format'
  }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :service_type, presence: true, inclusion: service_types.keys

  private

    def set_gopay
      gopay = Gopay.create(ref_type: "Driver", ref_id: id)
    end
end
