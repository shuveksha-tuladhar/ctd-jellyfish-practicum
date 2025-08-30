class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :payer, null: false, foreign_key: { to_table: :users }
      t.references :payee, null: false, foreign_key: { to_table: :users }
      t.references :user_group, null: false, foreign_key: true
      t.decimal :owed_amount
      t.decimal :paid_amount

      t.timestamps
    end
  end
end
