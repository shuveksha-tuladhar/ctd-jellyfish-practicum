class AddUserForeignKeysToPayments < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :payments, :users, column: :payer_id
    add_foreign_key :payments, :users, column: :payee_id
  end
end
