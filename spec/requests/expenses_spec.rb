require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:friend) { create(:user) } # for participants

  before do
    # Log in the user
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  describe "GET /expenses" do
    it "returns http success" do
      get expenses_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /expenses" do
    context "with valid parameters" do
      it "creates a new expense with participants" do
        expense_params = {
          expense: {
            title: "Internet Bill",
            amount: 50.0,
            split_type: "Equal",
            category_id: category.id,
            user_ids: [ friend.id ]
          }
        }

        expect {
          post expenses_path, params: expense_params
        }.to change(Expense, :count).by(1)
         .and change(ExpenseUser, :count).by(2) # creator + friend

        expense = Expense.last
        expect(expense.title).to eq("Internet Bill")
        expect(expense.amount).to eq(50.0)
        expect(expense.user).to eq(user)
        expect(expense.participants.pluck(:id)).to match_array([ user.id, friend.id ])
        expect(response).to redirect_to(expenses_path)
      end
    end

    context "with invalid parameters" do
      it "does not create an expense and returns unprocessable_content" do
        expense_params = {
          expense: {
            title: "",  # invalid
            amount: -5,
            split_type: "Equal"
          }
        }

        expect {
          post expenses_path, params: expense_params
        }.not_to change(Expense, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /expenses/:id" do
    let!(:expense) do
      exp = create(:expense, user: user, title: "Old Title", amount: 20.0, category: category)
      ExpenseUser.create!(user_id: user.id, expense_id: exp.id) # owner is participant
      exp
    end
    let!(:new_friend) { create(:user) }

    context "with valid parameters" do
      it "updates the expense and participants" do
        update_params = {
          expense: {
            title: "New Title",
            amount: 100.0,
            user_ids: [ new_friend.id ]
          }
        }

        patch expense_path(expense), params: update_params
        expense.reload

        expect(expense.title).to eq("New Title")
        expect(expense.amount).to eq(100.0)
        expect(expense.participants.pluck(:id)).to match_array([ user.id, new_friend.id ])
        expect(response).to redirect_to(expenses_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the expense and returns unprocessable_content" do
        update_params = {
          expense: {
            title: "", # invalid
            amount: -10
          }
        }

        patch expense_path(expense), params: update_params
        expense.reload

        # attributes remain unchanged
        expect(expense.title).to eq("Old Title")
        expect(expense.amount).to eq(20.0)

        # participants remain unchanged (owner still a participant)
        expect(expense.participants.pluck(:id)).to match_array([ user.id ])

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
