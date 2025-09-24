class BalancesController < ApplicationController
    before_action :require_login

    def index
      @user = current_user
      @balances = calculate_balance(@user)

      @you_are_owed = @balances.values.select { |v| v > 0 }.sum 
      @you_owe = @balances.values.select { |v| v < 0 }.sum.abs 
      @net_balance = @you_are_owed - @you_owe 
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
