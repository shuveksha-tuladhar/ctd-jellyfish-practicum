require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  let!(:user) { User.create!(first_name: "John", last_name: "Doe", email: "john@example.com", phone_number: "1234567890", password: "password") }
  let!(:friend) { User.create!(first_name: "Jane", last_name: "Smith", email: "jane@example.com", phone_number: "0987654321", password: "password") }

  describe "create relationship" do
    it "associates users correctly" do
      Friendship.create!(user: user, friend: friend, status: "accepted")
      expect(user.friends).to include(friend)
      expect(friend.received_friends).to include(user)
    end
  end
  describe "validations" do
    it "does not allow duplicate friendships" do
      Friendship.create!(user: user, friend: friend, status: "accepted")

      duplicate = Friendship.new(user: user, friend: friend, status: "accepted")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("has already been taken")
    end
  end
end
