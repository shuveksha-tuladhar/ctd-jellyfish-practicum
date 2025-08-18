class AddUserReferenceToExpenses < ActiveRecord::Migration[8.0]
  def change
    change_table :expenses do |t|
      t.remove :user_id
      t.references :user, null: true, foreign_key: true
    end
  end
end
