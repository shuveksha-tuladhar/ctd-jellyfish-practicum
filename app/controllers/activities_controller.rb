class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recent_activities = []

    # Recent expenses
    Expense.where(creator_id: current_user.id).order(created_at: :desc).limit(5).each do |expense|
      other_user = if expense.user_group.present?
                      expense.user_group.users.find { |u| u != current_user }
      else
                      expense.expense_users.map(&:user).find { |u| u != current_user }
      end


      @recent_activities << {
        type: "expense",
        name: expense.title,
        amount: expense.amount,
        with: other_user&.full_name || "Unknown",
        owes_you: expense.creator_id == current_user.id,
        created_at: expense.created_at
      }
    end

    # Recent groups
    if current_user.respond_to?(:groups)
      current_user.groups.order(created_at: :desc).limit(5).each do |group|
        @recent_activities << {
          type: "group",
          name: group.name,
          created_at: group.created_at
        }
      end
    end

    # Recent friendships
    current_user.friendships.order(created_at: :desc).limit(5).each do |friendship|
      @recent_activities << {
        type: "friend",
        name: friendship.friend&.full_name || "Unknown",
        created_at: friendship.created_at
      }
    end

    # Sort all activities by created_at descending
    @recent_activities = @recent_activities.sort_by { |a| a[:created_at] }.reverse
  end

  private

  def find_other_party_for(expense)
    # Try to determine who the expense was with
    if expense.user_group.present?
      expense.user_group.name
    elsif expense.creator != current_user
      expense.creator.full_name
    else
      "Unknown"
    end
  end

  def fetch_recent_activities
    activities = []

    # Example logic: Customize based on your app's models
    current_user.expenses.order(created_at: :desc).limit(10).each do |expense|
      other_person = expense.creator == current_user ? "You" : expense.creator.full_name

      activities << {
        type: "expense",
        nname: expense.title,
        amount: expense.amount,
        with: other_person,
        owes_you: expense.creator != current_user,
        created_at: expense.created_at
      }
    end

    current_user.user_groups.order(created_at: :desc).limit(5).each do |group|
      activities << {
        type: "group",
        name: group.name,
        created_at: group.created_at
      }
    end

    current_user.friendships.order(created_at: :desc).limit(5).each do |friendship|
      friend = friendship.friend
      activities << {
        type: "friend",
        name: friend.full_name,
        created_at: friendship.created_at
      }
    end

    # Sort all activities by created_at descending
    activities.sort_by { |a| a[:created_at] }.reverse
  end

  def find_other_user_in_expense(expense)
    # 1. Direct friend expense
    if expense.respond_to?(:splits) && expense.splits.any?
      # Assuming each split has a user_id
      other_split_user = expense.splits.map(&:user).find { |u| u != current_user }
      return other_split_user
    end

    # 2. Group expense — show first user in group who isn't current_user
    if expense.user_group && expense.user_group.users.any?
      return expense.user_group.users.find { |u| u != current_user }
    end

    # 3. Fallback
    expense.creator_id != current_user.id ? expense.creator : nil
  end
end
