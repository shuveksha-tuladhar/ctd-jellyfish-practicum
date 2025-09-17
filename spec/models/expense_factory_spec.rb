require 'rails_helper'

RSpec.describe 'Expense Factory' do
    it 'builds a valid expense' do
        expense = build(:expense)
        expect(expense).to be_valid
    end

    it 'creates an expense in the database' do
        expense = create(:expense)
        expect(expense).to be_persisted
    end

    it 'reuires a title' do
        expense = build(:expense, title: nil)
        expect(expense).to_not be_valid
        expect(expense.errors[:title]).to include("can't be blank")
    end

    it 'requires a positive amount' do
        expense = build(:expense, amount: -10)
        expect(expense).to_not be_valid
        expect(expense.errors[:amount]).to include("must be greater than 0")
    end

    it "is associated with a creator" do
        expense = create(:expense)
        expect(expense.creator).to be_present
    end
end
