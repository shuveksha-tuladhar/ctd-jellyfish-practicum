FactoryBot.define do
    factory :user do
      first_name { "Jenny" }
      last_name { "Wang" }
      email { Faker::Internet.unique.email }
      password { "password" }
      phone_number { Faker::Number.number(digits: 10).to_s }

  
      trait :with_expenses do
        after(:create) do |user|
          create_list(:expense, 3, user: user)
        end
      end
    end
end
  