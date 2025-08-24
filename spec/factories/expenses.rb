FactoryBot.define do 
    factory :expense do 
        title { "Lunch" }
        amount { 25.99 }
        split_type { "equal" }
        category_id { 1 }
        association :user 
    end 
end 
