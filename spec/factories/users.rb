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
        category = create(:category)

        create_list(:expense, 3, creator: user, user_group: group, category: category) do |expense|
          # add user as a participant in the join table
          create(:expense_user, user: user, expense: expense)
        end
      end
    end
  end
end
