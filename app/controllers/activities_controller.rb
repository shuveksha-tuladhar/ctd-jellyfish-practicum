class ActivitiesController < ApplicationController
  before_action :authenticate_user!


  def index
    @recent_activities = fetch_recent_activities
  end

  private

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
end
