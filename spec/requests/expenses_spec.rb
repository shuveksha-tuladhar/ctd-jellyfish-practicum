require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  let(:user) do
    User.create!(
      first_name: "Test",
      last_name: "User",
      email: "test@example.com",
      password: "password",
      phone_number: "1231231234"
    )
  end

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "GET /expenses" do
    it "returns http success" do
      get expenses_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /expenses" do
    it "creates a new expense" do
      expense_params = { expense: { title: "Internet Bill", amount: 50.0 } }

      expect {
        post expenses_path, params: expense_params
      }.to change(Expense, :count).by(1)

      expect(response).to redirect_to(expenses_path)
    end
  end
end
