class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :title
      t.decimal :amount, precision: 10, scale: 2
      t.string :split_type
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
  end
end
