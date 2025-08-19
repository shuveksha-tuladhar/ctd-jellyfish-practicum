require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", phone_number: "1231231234") }

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "GET /categories" do
    it "returns http success" do
      get categories_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /categories" do
    it "creates a new category" do
      category_params = { category: { name: "Bills" } }
      expect {
        post categories_path, params: category_params
      }.to change(Category, :count).by(1)
      expect(response).to redirect_to(categories_path)
    end
  end
end
