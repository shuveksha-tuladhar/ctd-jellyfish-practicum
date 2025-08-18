
require 'rails_helper'

RSpec.describe "Sessions", type: :request do
    describe "GET /login" do
        it "renders the login page" do
            get login_path
            expect(response).to have_http_status(:success)
        end
    end

    describe "POST /login" do
        let!(:user) do
            User.create!(
                first_name: "test",
                last_name: "test",
                email: "test@example.com",
                password: "password",
                phone_number: "1234567890"
            )
        end

        context "with valid credentials" do
            it "logs the user in and redirects" do
                post login_path, params: { session: { email: user.email, password: "password" } }
                expect(response).to redirect_to(user_path(user))
                follow_redirect!
                expect(response.body).to include("Welcome")
            end
        end

        context "with invalid credentials" do
            it "re-renders the login form with an error" do
                post login_path, params: { session: { email: user.email, password: "wrong" } }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.body).to include("Invalid")
            end
        end
    end

    describe "DELETE /logout" do
        let!(:user) do
            User.create!(
                first_name: "test", 
                last_name: "test", 
                email: "test2@axample.com", 
                password: "password", 
                phone_number: "1234567890"
            ) 
        end 

        before do
            post login_path, params: { session: { email: user.email, password: "password" } }
            follow_redirect!
        end

        it "logs the user out and redirects" do
            delete logout_path
            expect(response).to redirect_to(root_path)
            follow_redirect!
            expect(response.body).to include("You have been logged out.")
        end
    end
end
