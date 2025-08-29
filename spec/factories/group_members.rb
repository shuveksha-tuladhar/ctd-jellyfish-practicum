FactoryBot.define do
  factory :group_member do
    association :user
    association :user_group
  end
end
