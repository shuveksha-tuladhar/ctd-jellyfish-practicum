class Payment < ApplicationRecord
  belongs_to :expense
  belongs_to :payer, class_name: "User"
  belongs_to :payee, class_name: "User"
  belongs_to :user_group, optional: true

  validates :owed_amount, :paid_amount, presence: true, numericality: { greater_than: 0 }
end
