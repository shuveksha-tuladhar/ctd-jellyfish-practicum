require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user1) { User.create!(first_name: "John", last_name: "Doe", email: "john@example.com", password: "password", phone_number: "1234567890") }
  let!(:user2) { User.create!(first_name: "Jane", last_name: "Smith", email: "jane@example.com", password: "password", phone_number: "0987654321") }
  let!(:user3) { User.create!(first_name: "Alice", last_name: "Johnson", email: "alice@example.com", password: "password", phone_number: "5555555555") }

  let(:user) { user1 }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /users" do
    context "without query" do
      it "returns all users" do
        get users_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("John Doe", "Jane Smith", "Alice Johnson")
      end
    end

    context "with query" do
      it "returns users matching first name" do
        get users_path, params: { query: "Alice" }
        expect(response.body).to include("Alice Johnson")
      end

      it "returns users matching last name" do
        get users_path, params: { query: "Smith" }
        expect(response.body).to include("Jane Smith")
      end

      it "returns users matching full name" do
        get users_path, params: { query: "John Doe" }
        expect(response.body).to include("John Doe")
      end

      it "returns users matching full name in any order" do
        get users_path, params: { query: "Doe John" }
        expect(response.body).to include("Doe John")
      end

      it "returns users matching email" do
        get users_path, params: { query: "alice@example.com" }
        expect(response.body).to include("Alice Johnson")
      end

      it "returns no users if query does not match" do
        get users_path, params: { query: "Nonexistent" }
        expect(response.body).to include("No users found")
      end
    end
  end
end
