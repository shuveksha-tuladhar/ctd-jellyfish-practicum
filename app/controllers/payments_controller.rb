class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  def index
   @payments = @user.payments_made
  end

  def show
   @payment = @user.payments_made.find(params[:id])
  end

  def destroy
   @payment = @user.payments_made.find(params[:id])
   @payment.destroy
   flash[:alert] = "Deletion Successful"
   redirect_to user_payments_path(@user)
  end

private
   def set_user
      @user = current_user
   end
end
