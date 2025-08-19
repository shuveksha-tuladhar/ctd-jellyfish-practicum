class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
