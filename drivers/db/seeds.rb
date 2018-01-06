# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Driver.delete_all

Driver.create!(
  fullname: "Supir Motor",
  phone: "12345678901",
  email: "goride@mail.com",
  password: "password",
  service_type: "Go-Ride"
)

Driver.create!(
  fullname: "Supir Mobil",
  phone: "12345678902",
  email: "gocar@mail.com",
  password: "password",
  service_type: "Go-Car"
)
