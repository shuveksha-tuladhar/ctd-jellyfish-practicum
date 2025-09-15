class ChangeUserGroupIdNullableInExpenses < ActiveRecord::Migration[8.0]
  def change
    change_column_null :expenses, :user_group_id, true
  end
end
