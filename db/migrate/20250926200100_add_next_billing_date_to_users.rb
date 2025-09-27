class AddNextBillingDateToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :next_billing_date, :date
  end
end
