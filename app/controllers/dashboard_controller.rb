class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @groups = current_user.user_groups

    # Recent expenses with participants info
    @recent_expenses = current_user.expenses.includes(:participants).order(created_at: :desc).limit(5).map do |expense|
      expense.participants.map do |participant|
        {
          type: "expense",
          name: expense.title,
          amount: (expense.amount / (expense.participants.count + 1)), # split including current user
          with: participant.full_name, # assuming User#full_name exists
          created_at: expense.created_at
        }
      end
    end.flatten

    # Recent groups
    recent_groups = @groups.select(:id, :name, :created_at).map do |g|
      { type: "group", name: g.name, created_at: g.created_at }
    end

    # Recent friends
    recent_friends = current_user.friends.select(:id, :first_name, :created_at).map do |f|
      { type: "friend", name: f.first_name, created_at: f.created_at }
    end

    # Combine and sort all activities
    @recent_activities = (@recent_expenses + recent_groups + recent_friends)
                           .sort_by { |a| -a[:created_at].to_i }
                           .first(5)

    # Monthly spending
    @monthly_spending = current_user.expenses
                                    .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
                                    .sum(:amount)
  end
end
