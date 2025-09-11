class UserGroupsController < ApplicationController
  include SessionsHelper
  before_action :set_user_group, only: %i[show edit update destroy]
  before_action :require_login

  # GET /user_groups
  def index
  if params[:q].present?
    @user_groups = UserGroup
                   .joins("LEFT JOIN group_members ON group_members.user_group_id = user_groups.id")
                   .where("user_groups.created_by_user_id = :user_id OR group_members.user_id = :user_id", user_id: current_user.id)
                   .where("user_groups.name ILIKE ?", "%#{params[:q]}%")
                   .distinct
                   .order(created_at: :desc)
  else
    @user_groups = UserGroup
               .joins("LEFT JOIN group_members ON group_members.user_group_id = user_groups.id")
               .where("user_groups.created_by_user_id = ? OR group_members.user_id = ?", current_user.id, current_user.id)
               .distinct
               .order(created_at: :desc)
  end
end


  # GET /user_groups/1
  def show
  end

  # GET /user_groups/new
  def new
    @user_group = UserGroup.new
  end

 # POST /user_groups
 def create
  @user_group = UserGroup.new(user_group_params)
  @user_group.creator = current_user

  if @user_group.save
    unless @user_group.users.include?(current_user)
      @user_group.group_members.create(user: current_user)
    end

    redirect_to @user_group, notice: "Group was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
end


  # PATCH/PUT /user_groups/1
  def update
    if @user_group.update(user_group_params)
      redirect_to @user_group, notice: "Group was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_groups/1
  def destroy
    @user_group.destroy
    redirect_to user_groups_url, notice: "Group was successfully destroyed."
  end

  private

    def set_user_group
      @user_group = UserGroup.find(params[:id])
    end

    def user_group_params
       params.require(:user_group).permit(:name, :description, user_ids: [])
    end

    def require_login
      redirect_to login_path, alert: "Please log in." unless current_user
    end
end
