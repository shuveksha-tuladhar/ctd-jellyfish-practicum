class ExpenseUser < ApplicationRecord
  belongs_to :user
  belongs_to :expense
<<<<<<< HEAD

  validates :user_id, uniqueness: { scope: :expense_id }
=======
>>>>>>> 3bf7ab0 (Create E
end
