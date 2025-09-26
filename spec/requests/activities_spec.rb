require 'rails_helper'

RSpec.describe "Activities", type: :request do
  # Create a user
  let!(:user3) do
    User.create!(
      first_name: "Alice",
      last_name:  "Johnson",
      email:      "alice@example.com",
      password:   "password",
      phone_number: "5555555555"
    )
  end

  describe "GET /users/:id/activities" do
    context "when user is authenticated" do
      it "returns http success" do
        # Log in the user
        post login_path, params: {
          session: { email: user3.email, password: "password" }
        }

        get user_activities_path(user3) # matches your route
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not authenticated" do
      it "redirects to the login page" do
        get user_activities_path(user3)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
