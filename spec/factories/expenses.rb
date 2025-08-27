FactoryBot.define do
  factory :expense do
    title { "Lunch" }
    amount { 25.99 }
    split_type { "equal" }
    association :user
    association :category
    association :user_group
  end
end
