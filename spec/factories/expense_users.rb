FactoryBot.define do
  factory :expense_user do
    expense { nil }
    association :user
  end
end
