require 'rails_helper'

RSpec.describe ExpensesUser, type: :model do
  describe "associations" do
    it { should belong_to(:expense) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = create(:user)
      expense = create(:expense)
      expenses_user = ExpensesUser.new(user: user, expense: expense)

      expect(expenses_user).to be_valid
    end

    it "is not valid without a user" do
      expense = create(:expense)
      expenses_user = ExpensesUser.new(expense: expense)
      expect(expenses_user).not_to be_valid
    end

    it "is not valid without an expense" do
      user = create(:user)
      expenses_user = ExpensesUser.new(user: user)
      expect(expenses_user).not_to be_valid
    end
  end
end
