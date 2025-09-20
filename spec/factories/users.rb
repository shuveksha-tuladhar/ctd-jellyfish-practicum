FactoryBot.define do
  factory :user do
    first_name { "Jenny" }
    last_name  { "Wang" }
    email      { Faker::Internet.unique.email }
    password   { "password" }
    phone_number { Faker::Number.number(digits: 10).to_s }

    trait :with_expenses do
      after(:create) do |user|
        group = create(:user_group, creator: user)
        create_list(:expense, 3) do |expense|
          expense.user = user
          expense.user_group = group
          expense.save!
          create(:expense_user, user: user, expense: expense)
        end
      end
    end
  end
end
