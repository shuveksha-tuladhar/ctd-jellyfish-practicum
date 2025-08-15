class ExpensesController < ApplicationController
  before_action :set_expense

  # GET /expenses
  def index
    @expenses = current_user.expenses.includes(:category)
  end

  # GET /expenses/new (for modal)
  def new
    @expense = current_user.expenses.new

    if request.headers["Turbo-Frame"]
      render partial: "modal", locals: { expense: @expense }
    else
      redirect_to expenses_path
    end
  end

  # POST /expenses
  def create
    @expense = current_user.expenses.new(expense_params)

    if @expense.save
      respond_to do |format|
        format.html { redirect_to expenses_path, notice: "Expense created successfully." }
        format.turbo_stream { render turbo_stream: turbo_stream.append("expenses-list", partial: "expenses/expense", locals: { expense: @expense }) }
      end
    else
      render partial: "modal", locals: { expense: @expense }, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/:id
  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense deleted successfully."
  end

  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:title, :amount, :category_id)
  end
end
