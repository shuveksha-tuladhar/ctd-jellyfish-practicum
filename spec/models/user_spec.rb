require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) {
        User.create(
            first_name: "sisi",
            last_name: "wang",
            email: 'sisi.wang@example.com',
            password_digest: '123456',
            phone_number: '1234567890',
        )
    }

    describe 'validations' do
        it 'is valid when name is present' do
            expect(user).to be_valid
        end
        it 'is valid when email is present' do
            expect(user).to be_valid
        end
        it 'is not valid with a duplicate email' do
            duplicate_user = user.dup
            duplicate_user.email = user.email
            expect(duplicate_user).not_to be_valid
        end
        it 'is valid when phone is present' do
            expect(user).to be_valid
        end
    end
    describe "associations" do
        it "can have many expenses" do
            user = FactoryBot.create(:user)
            expense1 = FactoryBot.create(:expense, creator: user)
            expense2 = FactoryBot.create(:expense, creator: user)

            expect(user.created_expenses).to include(expense1, expense2)
            expect(user.created_expenses.count).to eq(2)
        end
    end
end
