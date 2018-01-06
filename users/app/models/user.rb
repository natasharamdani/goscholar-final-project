class User < ApplicationRecord
  has_secure_password

  after_create :set_gopay

  has_many :orders

  validates :fullname, presence: true
  validates :phone, presence: true, uniqueness: true, numericality: true, length: {minimum: 10, maximum: 13}
  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    message: 'has invalid format'
  }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: true

  private

    def set_gopay
      Gopay.create(ref_type: "User", ref_id: self.id)
    end
end
