class User < ApplicationRecord
    has_one_attached :profile_picture

    # User initiates the following
    has_many :friendships, foreign_key: :user_id, dependent: :destroy
    has_many :friends, through: :friendships, source: :friend

    # User recieves the follow
    has_many :received_friendships, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy
    has_many :received_friends, through: :received_friendships, source: :user

    has_secure_password
    attr_accessor :reset_token
    has_many :expenses, dependent: :destroy

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

    def self.search(query)
        return all if query.blank?

        query = query.strip.downcase

        where(
        "LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(email) LIKE :q
        OR (LOWER(first_name) || ' ' || LOWER(last_name)) LIKE :q
        OR (LOWER(last_name) || ' ' || LOWER(first_name)) LIKE :q",
        q: "%#{query}%"
        )
    end
end
