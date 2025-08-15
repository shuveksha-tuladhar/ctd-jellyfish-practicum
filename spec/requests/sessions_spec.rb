
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
                password_hash: "password",
                password__hash_confirmation: "password",
                phone_number: "1234567890"
            )
        end

        context "with valid credentials" do
            it "logs the user in and redirects" do
                post login_path, params: { session: { email: user.email, password_hash: "password" } }
                expect(response).to redirect_to(user_path(user))
                follow_redirect!
                expect(response.body).to include("Welcome")
                expect(session[:user_id]).to eq(user.id)
            end
        end

        context "with invalid credentials" do
            it "re-renders the login form with an error" do
                post login_path, params: { session: { email: user.email, password_hash: "wrong" } }
                expect(response).to have_http_status(:success)
                expect(response.body).to include("Invalid")
            end
        end
    end

    describe "DELETE /logout" do
        let!(:user) { User.create!(first_name: "test", last_name: "test", email: "test2@axample.com", password_hash: "password", password_hash_confirmation: "password", phone_number: "1234567890") }

        before do
            post login_path, params: { session: { email: user.email, password_hash: "password" } }
            expect(session[:user_id]).to eq(user.id)
        end

        it "logs the user out and redirects" do
            delete logout_path
            expect(session[:user_id]).to be_nil
            expect(response).to redirect_to(root_path)
        end
    end
end
