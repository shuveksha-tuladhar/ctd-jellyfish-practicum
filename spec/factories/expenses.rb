FactoryBot.define do
  factory :expense do
    title { "Lunch" }
    amount { 25.99 }
    split_type { "equal" }
    association :creator, factory: :user
    association :category
    association :user_group

    trait :with_payors do
      after(:create) do |expense|
        expense.payors << expense.creator
      end
    end

    trait :percentage_split do
      split_type { "percentage" }
    end
  end
end
