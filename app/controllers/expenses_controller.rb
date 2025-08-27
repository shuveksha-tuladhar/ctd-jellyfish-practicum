class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_expense, only: [ :show, :edit, :update, :destroy ]

  # GET /expenses
  def index
    if current_user
      @expenses = current_user.expenses
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
    @expense = current_user.expenses.build(expense_params)
    @expense.user_group ||= current_user.user_groups.first
    if @expense.save
      redirect_to expenses_path, notice: "Expense added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /expenses/:id/edit
  def edit
    # @expense is already set by set_expense
  end

  def show
    @expense = current_user.expenses.find(params[:id])
  end

  # PATCH/PUT /expenses/:id
  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Expense updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/:id
  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense deleted successfully."
  end

  private

  def set_expense
    @expense = current_user.expenses.find_by(id: params[:id])
    redirect_to expenses_path, alert: "Expense not found." unless @expense
  end

  def expense_params
    params.require(:expense).permit(:title, :amount, :category_id, :user_group_id)
  end

  def require_login
    redirect_to login_path, alert: "Please log in." unless current_user
  end
end
