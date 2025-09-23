class CreateExpenseSplits < ActiveRecord::Migration[8.0]
  def change
    create_table :expense_splits do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :percentage_split, precision: 5, scale: 2, null: false

      t.timestamps
    end

    add_index :expense_splits, [:expense_id, :user_id], unique: true
  end
end
