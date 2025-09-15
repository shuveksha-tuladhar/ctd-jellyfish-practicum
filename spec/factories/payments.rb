FactoryBot.define do
  factory :payment do
    expense { nil }
    payer { nil }
    payee { nil }
    user_group { nil }
    owed_amount { "9.99" }
    paid_amount { "9.99" }
  end
end
