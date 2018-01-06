# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Service.delete_all

Service.create!(
  service_type: "Go-Ride",
  price_per_km: 1500
)

Service.create!(
  service_type: "Go-Car",
  price_per_km: 2500
)

User.delete_all

User.create!(
  fullname: "Nanda",
  phone: "1234567891",
  email: "nanda@mail.com",
  password: "password"
)

User.create!(
  fullname: "Ajeng",
  phone: "1234567892",
  email: "ajeng@mail.com",
  password: "password"
)
