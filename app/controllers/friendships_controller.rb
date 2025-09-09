class FriendshipsController < ApplicationController
  before_action :require_login

  def index
    @friendships = current_user.friendships.includes(:friend)
    friend_ids = current_user.friendships.pluck(:friend_id).uniq
    @other_users = User.where.not(id: friend_ids + [ current_user.id ])
  end

  def create
    friend = User.find(params[:friend_id])
    friendship = current_user.friendships.build(friend_id: friend.id)
  
    if friendship.save
      #redirect_to user_friendship_path(current_user, friendship), notice: "Friend added successfully."
      redirect_to user_friendships_path(current_user), notice: "Friend added successfully."
    else
      #redirect_to friendships_path, alert: friendship.errors.full_messages.to_sentence
      redirect_to user_friendships_path(current_user), alert: friendship.errors.full_messages.to_sentence
    end
  end
  

  def show
    @friendship = current_user.friendships.find(params[:id])
  end

  def new
    @friendship = Friendship.new
    @users = User.where.not(id: current_user.id)
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy!
    redirect_to friendships_path, notice: "Unfriended successfully."
  end

  private

  def require_login
    redirect_to login_path, alert: "Please log in." unless current_user
  end
end
