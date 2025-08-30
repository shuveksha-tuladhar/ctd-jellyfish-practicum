class Payment < ApplicationRecord
  belongs_to :expense
  belongs_to :payer
  belongs_to :payee
  belongs_to :user_group
end
