class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @groups = current_user.user_groups
    @friends = current_user.friends

    # --- Recent Expenses with participant info and split calculation ---
    @recent_expenses = current_user.expenses.includes(:participants).order(created_at: :desc).limit(5).map do |expense|
      # Calculate splits using SplitCalculator (equal split example)
      splits_result = SplitCalculator.new(expense, split_type: :equal).call

      splits_result[:splits].map do |split|
        participant = User.find(split[:participant_id])
        next if participant == current_user # skip self

        {
          type: "expense",
          name: expense.title,
          amount: split[:share],
          with: participant.full_name,
          owes_you: participant.id != current_user.id, # placeholder logic
          created_at: expense.created_at
        }
      end.compact
    end.flatten

    # --- Recent Groups ---
    @recent_groups = @groups.map do |g|
      { type: "group", name: g.name, created_at: g.created_at }
    end

    # --- Recent Friends ---
    @recent_friends = @friends.map do |f|
      { type: "friend", name: f.first_name, created_at: f.created_at }
    end

    # --- Combine all activities and sort ---
    @recent_activities = (@recent_expenses + @recent_groups + @recent_friends)
                           .sort_by { |a| -a[:created_at].to_i }
                           .first(10)

    # --- Monthly Spending ---
    @monthly_spending = current_user.expenses
                                    .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
                                    .sum(:amount)
                                    .to_f
                                    .round(2)
  end
end
