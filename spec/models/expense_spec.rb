require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  subject do
    described_class.new(
      title: "Sample Expense",
      amount: 50.0,
      creator: user,
      category: category,
      split_type: "equal"
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
    it "belongs to a creator (User)" do
      assoc = described_class.reflect_on_association(:creator)
      expect(assoc.macro).to eq :belongs_to
      expect(assoc.class_name).to eq "User"
    end

    it "belongs to a category" do
      assoc = described_class.reflect_on_association(:category)
      expect(assoc.macro).to eq :belongs_to
    end

    it "has many payors through ExpensesUser" do
      assoc = described_class.reflect_on_association(:payors)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:through]).to eq :expenses_users
    end
  end
end
