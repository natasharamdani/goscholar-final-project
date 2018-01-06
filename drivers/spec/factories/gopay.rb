FactoryGirl.define do
  factory :gopay do
    balance 20000
  end

  factory :invalid_gopay, parent: :gopay do
    balance nil
  end
end
