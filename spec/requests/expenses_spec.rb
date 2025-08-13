require 'rails_helper'

RSpec.describe "Expenses", type: :request do

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
      
      expect(response).to redirect_to(assigns(:expense))
    end
  end
end
