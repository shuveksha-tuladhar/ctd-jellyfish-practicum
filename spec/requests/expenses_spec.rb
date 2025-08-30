require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  let(:user) { create(:user) }
  let(:user_group) { create(:user_group, creator: user) }
  let(:category) { create(:category) }

  before do
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  describe "GET /expenses" do
    it "returns http success" do
      get expenses_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /expenses" do
    it "creates a new expense" do
      expense_params = {
        expense: {
          title: "Internet Bill",
          amount: 50.0,
          split_type: "equal",
          category_id: category.id,
          user_group_id: user_group.id
        }
      }

      expect {
        post expenses_path, params: expense_params
      }.to change(Expense, :count).by(1)

      expect(response).to redirect_to(expenses_path)

      expense = Expense.last
      expect(expense.title).to eq("Internet Bill")
      expect(expense.amount).to eq(50.0)
      expect(expense.user_group).to eq(user_group)
      expect(expense.user).to eq(user)
    end
  end
end
