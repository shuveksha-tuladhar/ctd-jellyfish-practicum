require 'rails_helper'

RSpec.describe Expense, type: :model do
  subject do
    described_class.new(
      title: "Sample Expense",
      amount: 50.0
      # no user or category associations for now
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


  # Unskip once foreign key is added to user, category table
  describe "associations" , skip: true do
    it "belongs to a user" do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to a category" do
      assoc = described_class.reflect_on_association(:category)
      expect(assoc.macro).to eq :belongs_to
    end

    it "can have many users through user_expenses" do
      assoc = described_class.reflect_on_association(:users)
      expect(assoc.macro).to eq :has_many
    end
  end

end

