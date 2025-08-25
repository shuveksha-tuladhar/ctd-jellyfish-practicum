require 'rails_helper'

RSpec.describe 'Friendship Factory' do
    it 'builds a valid friendship' do
        friendship = build(:friendship)
        expect(friendship).to be_valid
    end

    it 'creates a friendship in the database' do
        friendship = create(:friendship)
        expect(friendship).to be_persisted
    end

    it 'validates uniqueness of friend per user' do
        user = create(:user)
        friend = create(:user)
        create(:friendship, user: user, friend: friend)
        duplicate = build(:friendship, user: user, friend: friend)
        expect(duplicate).to_not be_valid
        expect(duplicate.errors[:friend_id]).to include("friendship already exists")
    end
end
