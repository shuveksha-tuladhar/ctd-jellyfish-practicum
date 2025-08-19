require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with a name" do
    category = Category.new(name: "Utilities")
    expect(category).to be_valid
  end

  it "is invalid without a name" do
    category = Category.new(name: nil)
    expect(category).not_to be_valid
  end

  it "has many expenses" do
    category = Category.create!(name: "Food")
    user = User.create!(first_name: "John", last_name: "Doe", email: "john@example.com", password: "password", phone_number: "1231231234")
    expense = Expense.create!(title: "Lunch", amount: 10, user: user, category: category)
    expect(category.expenses).to include(expense)
  end
end
