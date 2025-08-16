class PasswordResetsController < ApplicationController
    def new
    end

    def create
        @user = User.find_by(email: params[:email])
        if @user
            @user.generate_password_reset_token!
            PasswordResetMailer.with(user: @user).reset_email.deliver_now
            redirect_to login_path, notice: "Reset password instructions has been sent to your email."
        else
            flash.now[:alert] = "Email address not found."
            render :new
        end
    end

    def edit
        @user = User.find_by(reset_digest: Digest::SHA256.hexdigest(params[:id]))
        unless @user && valid_token?(@user, params[:id])
            redirect_to new_password_reset_path, alert: "Invalid or expired token."
        end
    end

    def update
        @user = User.find_by(reset_digest: Digest::SHA256.hexdigest(params[:id]))
        if @user && valid_token?(@user, params[:id])
            if @user.update(password_params)
                @user.update(reset_digest: nil, reset_sent_at: nil)
                redirect_to login_path, notice: "Password has been reset!"
            else
                render :edit
            end
        else
            redirect_to new_password_reset_path, alert: "Invalid or expired token."
        end
    end

    private
    def valid_token?(user, token)
        ActiveSupport::SecurityUtils.secure_compare(
            Digest::SHA256.hexdigest(token),
            user.reset_digest
          ) && user.reset_sent_at > 30.minutes.ago
    end

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end
