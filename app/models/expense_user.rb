class ExpenseUser < ApplicationRecord
  belongs_to :user
  belongs_to :expense


  validates :user_id, uniqueness: { scope: :expense_id }
end
