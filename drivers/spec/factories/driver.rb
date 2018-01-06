FactoryGirl.define do
  factory :driver do
    fullname { Faker::Name.name_with_middle }
    phone { Faker::Number.unique.number(12) }
    email { Faker::Internet.unique.email }
    password "password"
    password_confirmation "password"
  end

  factory :invalid_driver, parent: :driver do
    fullname nil
    phone nil
    email nil
    password nil
    password_confirmation nil
  end
end
