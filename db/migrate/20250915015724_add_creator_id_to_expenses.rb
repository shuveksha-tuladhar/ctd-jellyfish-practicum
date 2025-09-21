class AddCreatorIdToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :creator_id, :integer
    add_index :expenses, :creator_id
  end
end
