FactoryBot.define do
  factory :user_group do
    sequence(:name) { |n| "Group #{n}" }
    description { "Test group" }
    association :creator, factory: :user
  end
end
