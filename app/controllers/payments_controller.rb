class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  def index
   @payments = @user.payments_made
  end

  def show
   @payment = @user.payments_made.find(params[:id])
  end

  def new
   @payment = @user.payments_made.new(payee_id: current_user.id)
   @expenses = @user.expenses
  end

  def create
   @payment = @user.payments_made.build(payments_params)
   if @payment.save
      flash[:notice] = "Payment Created Sucessful"
      redirect_to user_payments_path(@user)
   else
      flash.now[:alert] = @payment.errors.full_messages.to_sentence
      @expenses = @user.expenses
      render :new, status: :unprocessable_entity
   end
  end

  def edit
   @payment = @user.payments_made.find(params[:id])
   @expenses = @user.expenses
  end

  def update
   @payment = @user.payments_made.find(params[:id])
      if @payment.update(payments_params)
        flash[:notice] = "Payment Updated"
        redirect_to user_payments_path(@user)
      else
        flash[:alert] = "Something went wrong"
        @expenses = @user.expenses
        render :edit, status: :unprocessable_entity
      end
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
   def payments_params
      params.require(:payment).permit(:expense_id, :payee_id, :payer_id, :user_group_id, :owed_amount, :paid_amount)
   end
end
