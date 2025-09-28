FactoryBot.define do
  factory :payment do
    owed_amount { 9.99 }
    paid_amount { 9.99 }

    association :payer, factory: :user
    association :payee, factory: :user
    association :expense
    association :user_group
  end
end
