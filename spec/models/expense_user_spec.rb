require 'rails_helper'

RSpec.describe ExpenseUser, type: :model do
  let(:user) do
    User.create(
      first_name: "abraham",
      last_name: "flores",
      email: 'abrahamflores@example.com',
      password_digest: '123456',
      phone_number: '1234567890'
    )
  end

  let(:expense) do
    Expense.create(
      title: "Lunch",
      amount: 20.0,
      creator: user,
      status: "pending"
    )
  end

  describe "associations" do
    it "belongs to a user" do
      expense_user = ExpenseUser.new(user: user, expense: expense)
      expect(expense_user.user).to eq(user)
    end

    it "belongs to an expense" do
      expense_user = ExpenseUser.new(user: user, expense: expense)
      expect(expense_user.expense).to eq(expense)
    end
  end

  describe "validations" do
    it "is valid with a unique user_id and expense_id combination" do
      first_record = ExpenseUser.create(user: user, expense: expense)
      second_record = ExpenseUser.new(user: user, expense: expense)
      expect(second_record.valid?).to be false
      expect(second_record.errors[:user_id]).to include("has already been taken")
    end

    it "allows a different user for the same expense" do
      another_user = User.create(
        first_name: "John",
        last_name: "Doe",
        email: 'john.doe@example.com',
        password_digest: '123456',
        phone_number: '9876543210'
      )
      record = ExpenseUser.new(user: another_user, expense: expense)
      expect(record.valid?).to be true
    end

    it "allows the same user for a different expense" do
      another_expense = Expense.create(
        title: "Dinner",
        amount: 30.0,
        creator: user,
        status: "pending"
      )
      record = ExpenseUser.new(user: user, expense: another_expense)
      expect(record.valid?).to be true
    end
  end
end
