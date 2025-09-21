FactoryBot.define do
  factory :expenses_user do
    association :expense
    association :user
  end
end
