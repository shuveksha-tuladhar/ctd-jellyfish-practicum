require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", phone_number: "1231231234") }
  let(:participant1) { User.create!(first_name: "Alice", last_name: "Smith", email: "alice@example.com", password: "password", phone_number: "1111111111") }
  let(:participant2) { User.create!(first_name: "Bob", last_name: "Johnson", email: "bob@example.com", password: "password", phone_number: "2222222222") }
  let(:non_participant) { User.create!(first_name: "Eve", last_name: "Adams", email: "eve@example.com", password: "password", phone_number: "3333333333") }


  let(:expense) { user.created_expenses.create!(title: "Lunch", amount: 50.0, split_type: "Equal", category_id: 1) }

  before do
    ExpenseUser.create!(user: participant1, expense: expense)
    ExpenseUser.create!(user: participant2, expense: expense)
  end

  it "includes all associated participants" do
    expect(expense.participants).to include(participant1, participant2)
  end

  it "does not include users not associated with the expense" do
    expect(expense.participants).not_to include(non_participant)
  end

  it "has the correct number of participants" do
    expect(expense.participants.count).to eq(2)
  end

  subject do
    described_class.new(
      title: "Sample Expense",
      amount: 50.0,
      user: user
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a title" do
      subject.title = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it "is not valid without an amount" do
      subject.amount = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("can't be blank")
    end

    it "is not valid if amount is less than or equal to zero" do
      subject.amount = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("must be greater than 0")
    end
  end

  describe "associations" do
    it "belongs to a user" do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to a category" do
      assoc = described_class.reflect_on_association(:category)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
