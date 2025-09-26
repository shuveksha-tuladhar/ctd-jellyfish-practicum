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

    has_many :created_expenses, class_name: "Expense", foreign_key: :creator_id, dependent: :destroy

    has_many :expense_users, dependent: :destroy
    has_many :expenses, through: :expense_users

    has_many :payments_made, class_name: "Payment", foreign_key: :payer_id, dependent: :destroy
    has_many :payments_received, class_name: "Payment", foreign_key: :payee_id, dependent: :destroy

    validates :first_name, :last_name, :email, presence: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone_number, uniqueness: true, format: {
        with: /\A\d{10}\z/,
        message: "must be a 10 digits (US format)"
    }

    has_many :created_groups, class_name: "UserGroup", foreign_key: :created_by_user_id
    has_many :group_members
    has_many :user_groups, through: :group_members

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

    def full_name
        "#{first_name} #{last_name}"
    end

    def balance_summary
        balances = Hash.new(0)
      
        # Debts from expenses - user owes others
        expenses.each do |expense|
          next unless expense.user_group_id
      
          group_members = UserGroup.find(expense.user_group_id).users
          split_amount = expense.amount.to_f / group_members.count
      
          group_members.each do |member|
            next if member == self
            balances[member] -= split_amount
          end
      
          balances[self] += expense.amount.to_f
        end
      
        # Payments made
        payments_made.each do |payment|
          balances[payment.payee] += payment.paid_amount.to_f
        end
      
        # Payments received
        payments_received.each do |payment|
          balances[payment.payer] -= payment.paid_amount.to_f
        end
      
        you_are_owed = balances.values.select { |v| v > 0 }.sum
        you_owe = balances.values.select { |v| v < 0 }.sum.abs
        net_balance = you_are_owed - you_owe
      
        {
          balances: balances,
          you_are_owed: you_are_owed,
          you_owe: you_owe,
          net_balance: net_balance
        }
    end   
end
