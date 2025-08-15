class User < ApplicationRecord
    has_one_attached :profile_picture
    has_secure_password
    attr_accessor :reset_token

    validates :first_name, :last_name, :email, presence: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone_number, uniqueness: true, format: {
        with: /\A\d{10}\z/,
        message: "must be a 10 digits (US format)"
    }

    def generate_password_reset_token!
        self.reset_token = SecureRandom.urlsafe_base64
        self.reset_digest = Digest::SHA256.hexdigest(reset_token)
        self.reset_sent_at = Time.current
        save!
    end
end
