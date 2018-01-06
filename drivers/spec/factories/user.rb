FactoryGirl.define do
  factory :user do
    fullname { Faker::Name.name_with_middle }
    phone { Faker::Number.unique.number(12) }
    email { Faker::Internet.unique.email }
    password "password"
    password_confirmation "password"
  end

  factory :invalid_user, parent: :user do
    fullname nil
    phone nil
    email nil
    password nil
    password_confirmation nil
  end
end
