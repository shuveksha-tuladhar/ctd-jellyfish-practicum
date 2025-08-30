class GroupMembersController < ApplicationController
  before_action :set_user_group

  def index
     @members = @user_group.group_members.includes(:user)
     render json: @members.as_json(include: :user)
  end

  def create
    @member = @user_group.group_members.new(group_member_params)
    if @member.save
      redirect_to user_group_group_members_path(@user_group), notice: "Member added successfully."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @member = @user_group.group_members.find(params[:id])
    @member.destroy
    redirect_to user_group_group_members_path(@user_group), notice: "Member removed successfully."
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end

  def group_member_params
    params.require(:group_member).permit(:user_id)
  end
end
