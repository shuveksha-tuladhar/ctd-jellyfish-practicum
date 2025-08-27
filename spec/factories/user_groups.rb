FactoryBot.define do
  factory :user_group do
    sequence(:name) { |n| "Group #{n}" }
    association :creator, factory: :user
  end
end
