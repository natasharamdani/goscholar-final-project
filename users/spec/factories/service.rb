FactoryGirl.define do
  factory :service do
    service_name "Go-Ride"
    price_per_km 1500
  end

  factory :invalid_service, parent: :service do
    service_name "Grab Car"
    price_per_km nil
  end
end
