class Payment < ApplicationRecord
  belongs_to :expense
  belongs_to :payer
  belongs_to :payee
  belongs_to :user_group

  validates :owed_amount, :paid_amount, presence: true, numericality: { greater_than: 0 }
end
