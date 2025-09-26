class BalancesController < ApplicationController
    before_action :require_login

    def index
      summary = current_user.balance_summary
      @balances = summary[:balances]
      @you_are_owed = summary[:you_are_owed]
      @you_owe = summary[:you_owe]
      @net_balance = summary[:net_balance]
    end

    private

    def calculate_balance(user)
      balances = Hash.new(0)

      # Add debts from expenses - user owes others
      user.expenses.each do |expense|
        next unless expense.user_group_id # skip if no group

        group_members = UserGroup.find(expense.user_group_id).users
        split_amount = expense.amount.to_f / group_members.count

        group_members.each do |member|
          next if member == user
          balances[member] -= split_amount
        end

        balances[user] += expense.amount.to_f
      end

      # Subtract payments made (user has paid someone)
      user.payments_made.each do |payment|
        balances[payment.payee] += payment.paid_amount.to_f
      end

      # Add payments received (user has received money)
      user.payments_received.each do |payment|
        balances[payment.payer] -= payment.paid_amount.to_f
      end

      balances
    end
end
