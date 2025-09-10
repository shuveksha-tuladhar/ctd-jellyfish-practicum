require "rails_helper"

RSpec.describe Payment, type: :model do
  let(:creator) do
    User.create!(
      first_name: "Creator",
      last_name: "User",
      email: "creator@example.com",
      password: "password",
      phone_number: "1234567890"
    )
  end

  let(:payer) do
    User.create!(
      first_name: "Alice",
      last_name: "Smith",
      email: "alice@example.com",
      password: "password",
      phone_number: "2345678901"
    )
  end

  let(:payee) do
    User.create!(
      first_name: "Bob",
      last_name: "Jones",
      email: "bob@example.com",
      password: "password",
      phone_number: "3456789012"
    )
  end

  let(:group) do
    UserGroup.create!(
      name: "Friends",
      description: "Test group",
      created_by_user_id: creator.id
    )
  end

  let(:expense) do
    Expense.create!(
      title: "Dinner",
      amount: 100,
      split_type: "equal",
      user_id: creator.id,
      user_group_id: group.id
    )
  end

  describe "associations" do
    it "belongs to an expense" do
      payment = Payment.create!(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 50,
        paid_amount: 50
      )
      expect(payment.expense).to eq(expense)
    end

    it "belongs to a payer (User)" do
      payment = Payment.create!(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 10,
        paid_amount: 10
      )
      expect(payment.payer).to eq(payer)
    end

    it "belongs to a payee (User)" do
      payment = Payment.create!(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 10,
        paid_amount: 10
      )
      expect(payment.payee).to eq(payee)
    end

    it "belongs to a user_group" do
      payment = Payment.create!(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 10,
        paid_amount: 10
      )
      expect(payment.user_group).to eq(group)
    end
  end

  describe "validations" do
    it "is valid with owed_amount and paid_amount > 0" do
      payment = Payment.new(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 20,
        paid_amount: 20
      )
      expect(payment).to be_valid
    end

    it "is invalid with owed_amount <= 0" do
      payment = Payment.new(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 0,
        paid_amount: 10
      )
      expect(payment).not_to be_valid
      expect(payment.errors[:owed_amount]).to include("must be greater than 0")
    end

    it "is invalid with paid_amount <= 0" do
      payment = Payment.new(
        expense: expense,
        payer: payer,
        payee: payee,
        user_group: group,
        owed_amount: 10,
        paid_amount: 0
      )
      expect(payment).not_to be_valid
      expect(payment.errors[:paid_amount]).to include("must be greater than 0")
    end
  end
end
