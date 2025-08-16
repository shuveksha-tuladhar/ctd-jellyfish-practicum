require 'rails_helper'

RSpec.describe Expense, type: :model do
    let(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", phone_number: "1231231234") }

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


  # Unskip once foreign key is added to category table
  describe "associations" do
    it "belongs to a user" do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to a category", skip: true do
      assoc = described_class.reflect_on_association(:category)
      expect(assoc.macro).to eq :belongs_to
    end

  end
end
