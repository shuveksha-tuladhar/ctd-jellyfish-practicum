class ExpenseSplit < ApplicationRecord
    belongs_to :expense
    belongs_to :user

 validates :percentage_split,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true,
            if: -> { expense&.split_type == "percentage" }

    validates :user_id, uniqueness: { scope: :expense_id, message: "already has a split for this expense" }
end
