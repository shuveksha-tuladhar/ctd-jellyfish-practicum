FactoryBot.define do
  factory :expense do
    title { "Lunch" }
    amount { 25.99 }
    split_type { "equal" } # default split type
    association :user
    association :category
    association :user_group

    trait :percentage_split do
      split_type { "percentage" }
    end
  end
end
