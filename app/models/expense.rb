class Expense < ApplicationRecord
  belongs_to :user

  has_many :expense_users, dependent: :destroy
  has_many :participants, through: :expense_users, source: :user

  belongs_to :category, optional: true
  belongs_to :user_group, optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
