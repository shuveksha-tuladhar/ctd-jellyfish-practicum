class PasswordResetMailer < ApplicationMailer
    def reset_email
        @user = params[:user]
        @token = @user.reset_token
        mail(
            to: @user.email,
            subject: "Reset Your Password",
            template_path: "password_resets",
            template_name: "reset_email"
        )
    end
end
