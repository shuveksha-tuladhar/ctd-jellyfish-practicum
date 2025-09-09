class ExpenseUser < ApplicationRecord
  belongs_to :user
  belongs_to :expense

<<<<<<< HEAD

=======
>>>>>>> 3243b1b (User-Expense_user-expense associations & validation)
  validates :user_id, uniqueness: { scope: :expense_id }
end
