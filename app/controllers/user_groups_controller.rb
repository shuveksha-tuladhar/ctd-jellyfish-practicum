class UserGroupsController < ApplicationController
  include SessionsHelper
  before_action :set_user_group, only: %i[show edit update destroy]
  before_action :require_login

  # GET /user_groups
  def index
    @user_groups = UserGroup.all
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
    @user_group.creator = current_user   # assign current_user as creator

    if @user_group.save
      # Add creator as first member
      @user_group.group_members.create(user: current_user)

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
      params.require(:user_group).permit(:name, :description)
    end

   def require_login
      redirect_to login_path, alert: "Please log in." unless current_user
   end
end
