require 'rails_helper'

RSpec.describe 'User Factory' do 
  it 'builds a valid user' do 
    user = build(:user)
    expect(user).to be_valid
  end

  it 'creates a user in the database' do 
    user = create(:user)
    expect(user).to be_persisted
  end

  it 'encrypts the password with has_secure_password' do 
    user = create(:user, password: 'secret123')
    expect(user.authenticate('secret123')).to eq(user)
  end

  context 'with_expenses trait' do 
    it 'creates a user with 3 expenses' do 
      user = create(:user, :with_expenses)
      expect(user.expenses.count).to eq(3)
    end
  end
end
