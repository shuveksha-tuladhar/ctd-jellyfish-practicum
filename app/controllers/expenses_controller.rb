class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_expense, only: [ :show, :edit, :update, :destroy ]

  # GET /expenses
  def index
    if current_user
      @expenses = current_user.created_expenses
    else
      redirect_to login_path, alert: "Please log in."
    end
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # POST /expenses

  def create
    @expense = current_user.created_expenses.new(expense_params.except(:user_ids))
    if @expense.save

      ExpenseUser.create!(user_id: current_user.id, expense_id: @expense.id)

      expense_params[:user_ids]&.reject(&:blank?)&.each do |id|
        ExpenseUser.create!(user_id: id, expense_id: @expense.id)
      end


      redirect_to expenses_path, notice: "Expense created successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  # GET /expenses/:id/edit
  def edit
    # @expense is already set by set_expense
  end

  def show
  end

  # PATCH/PUT /expenses/:id
  def update
    if @expense.update(expense_params.except(:user_ids))

      @expense.expense_users.where.not(user_id: @expense.user_id).destroy_all
      # remove old particpants in Expense User

      expense_params[:user_ids]&.reject(&:blank?)&.each do |id|
        ExpenseUser.find_or_create_by!(user_id: id, expense_id: @expense.id)
      end

      redirect_to expenses_path, notice: "Expense updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /expenses/:id
  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense deleted successfully."
  end

  private

  def set_expense
    @expense = current_user.created_expenses.find_by(id: params[:id])
    redirect_to expenses_path, alert: "Expense not found." unless @expense
  end

  def expense_params
    params.require(:expense).permit(:title, :amount, :split_type, :category_id, user_ids: [])
  end

  def require_login
    redirect_to login_path, alert: "Please log in." unless current_user
  end
end
