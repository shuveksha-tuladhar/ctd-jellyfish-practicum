class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  def index
   @payments = @user.payments_made
  end

  def show
  end

  def destroy
  end

  def new
  end

  def create
  end

private
   def set_user
      @user = current_user
   end
end
