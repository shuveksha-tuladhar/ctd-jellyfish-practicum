require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  let!(:user)   { User.create!(first_name: "John", last_name: "Doe", email: "john@example.com", phone_number: "1234567890", password: "password") }
  let!(:friend) { User.create!(first_name: "Jane", last_name: "Smith", email: "jane@example.com", phone_number: "0987654321", password: "password") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST /users/:user_id/friendships" do
    it "creates a new friendship" do
      expect {
        post user_friendships_path(user), params: { friend_id: friend.id }
      }.to change(Friendship, :count).by(1)

      expect(response).to redirect_to(user_friendships_path(user))

      follow_redirect!
    end
  end



  describe "GET /users/:user_id/friendships/:id" do
    it "shows a single friendship" do
      friendship = Friendship.create!(user: user, friend: friend)
      get user_friendship_path(user, friendship)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(friend.email)
    end
  end

  describe "DELETE /users/:user_id/friendships/:id" do
    it "destroys a friendship" do
      friendship = Friendship.create!(user: user, friend: friend)
      expect {
        delete user_friendship_path(user, friendship)
      }.to change(Friendship, :count).by(-1)
      expect(response).to redirect_to(user_friendships_path(user))
    end
  end
end
