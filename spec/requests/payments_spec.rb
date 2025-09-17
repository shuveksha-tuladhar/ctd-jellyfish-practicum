require 'rails_helper'

RSpec.describe PaymentsController, type: :request do
  let!(:payer) do
    User.create!(
      first_name: "Alice",
      last_name: "Smith",
      email: "alice@example.com",
      password: "password",
      phone_number: "8888888888"
    )
  end

  let!(:payee) do
    User.create!(
      first_name: "Bob",
      last_name: "Jones",
      email: "bob@example.com",
      password: "password",
      phone_number: "7777777777"
    )
  end

  let!(:creator) do
    User.create!(
      first_name: "Creator",
      last_name: "User",
      email: "creator@example.com",
      password: "password",
      phone_number: "9999999999"
    )
  end

  let!(:group) do
    UserGroup.create!(name: "Friends", description: "Test group", created_by_user_id: creator.id)
  end

  let!(:expense) do
    Expense.create!(title: "Dinner", amount: 100, split_type: "equal", creator: creator, user_group_id: group.id)
  end

  let!(:payment) do
    Payment.create!(expense: expense, payer: payer, payee: payee,
                    user_group: group, owed_amount: 50, paid_amount: 50)
  end

  before do
    # Fake login by overriding current_user
    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(payer)
    log_in_as(payer)
  end

  describe "GET #index" do
    it "returns a success response and lists payments made by the user" do
      get user_payments_path(payer)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(payment.owed_amount.to_s)
    end
  end

  describe "POST #create" do
    it "renders new when params are invalid" do
      post user_payments_path(payer), params: { payment: { owed_amount: -10 } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("New Payment")
    end
  end

  describe "PATCH #update" do
    it "renders edit when params are invalid" do
      patch user_payment_path(payer, payment), params: { payment: { owed_amount: -1 } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Edit Payment")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested payment" do
      expect {
        delete user_payment_path(payer, payment)
      }.to change(Payment, :count).by(-1)

      expect(response).to redirect_to(user_payments_path(payer))
      expect(flash[:alert]).to eq("Deletion Successful")
    end
  end
end
