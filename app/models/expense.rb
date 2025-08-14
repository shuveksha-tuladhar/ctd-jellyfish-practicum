class Expense < ApplicationRecord
  # Uncomment once foreign key is added
  # belongs_to :user
  # belongs_to :category

  validates :title, presence: true, length: { maximum: 100 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
