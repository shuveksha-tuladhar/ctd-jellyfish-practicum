class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :upload_photo]
  
    include Rails.application.routes.url_helpers
  
    # GET /users or /users.json
    def index
      @users = User.all
    end
  
    # GET /users/1 or /users/1.json
    def show
    end
  
    # GET /users/new
    def new
      @user = User.new
    end
  
    # GET /users/1/edit
    def edit
    end
  
    # POST /users or /users.json
    def create
      @user = User.new(user_params)
  
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: "User was successfully created." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /users/1
    def update
      # If password fields are filled, update password as well
      if password_present?
        if @user.authenticate(params[:user][:current_password])
          if @user.update(user_params_with_password)
            redirect_to edit_user_path(@user), notice: "Profile and password updated successfully."
          else
            flash.now[:alert] = "Update failed. Check your inputs."
            render :edit
          end
        else
          flash.now[:alert] = "Current password is incorrect."
          render :edit
        end
      else
        # Only update profile info
        if @user.update(user_params)
          redirect_to edit_user_path(@user), notice: "Profile updated successfully."
        else
          flash.now[:alert] = "Profile update failed."
          render :edit
        end
      end
    end
  
    # DELETE /users/1
    def destroy
      @user.destroy!
  
      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    def profile_picture_url
      url_for(profile_picture) if profile_picture.attached?
    end
  
    def upload_photo
      if @user.update(user_params)
        redirect_to @user, notice: "Profile picture updated"
      else
        render :upload_photo
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :currency, :language, :profile_picture)
    end
  
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  
    def user_params_with_password
      user_params.merge(password_params)
    end
  
    def password_present?
      params[:user][:password].present? || params[:user][:password_confirmation].present? || params[:user][:current_password].present?
    end
  end
  