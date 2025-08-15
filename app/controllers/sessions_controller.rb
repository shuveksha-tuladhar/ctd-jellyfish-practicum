class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email]&.downcase)
        if user&.authenticate(params[:password])
            log_in(user)
            redirect_to user
        else
            flash.now[:danger] = "Invalid email/passowrd combination"
            render "new"
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to login_path, notice: "You have been logged out."
    end
end
