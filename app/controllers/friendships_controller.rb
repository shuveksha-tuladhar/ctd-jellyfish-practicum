class FriendshipsController < ApplicationController
  before_action :set_user
  before_action :require_login

  # redirects route

  def index
    # show user's friendships
    @friendships = @user.friendships
    @users = User.all
  end

  def show
    @friendship = @user.friendships.find(params[:id])
  end

  # def edit
  #   @friendship = @user.friendships.find(params[:id])
  # end

  # def update
  #   @friendship = @user.friendships.find(params[:id])
  #   if @friendship.update(friendship_params)
  #     redirect_to user_friendship_path
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  def new
    @friendship = Friendship.new
    @users = User.where.not(id: @user.id)
  end

def create
  @friendship = @user.friendships.build(
    friend_id: params[:friendship][:friend_id],
    status: "pending"
  )

  if @friendship.save
    redirect_to user_friendships_path(@user)
  else
    render :new, status: :unprocessable_entity
  end
end

  def destroy
    @friendship = @user.friendships.find(params[:id])
    @friendship.destroy!
    redirect_to users_path
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def require_login
    redirect_to login_path, alert: "Please log in." unless current_user
  end
end
