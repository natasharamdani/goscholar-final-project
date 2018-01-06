FactoryGirl.define do
  factory :order do
    origin "Kemang"
    destination "Blok M"
    payment_type "Cash"
  end

  factory :invalid_order, parent: :order do
    payment_type nil
  end
end
