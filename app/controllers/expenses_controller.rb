class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_expense, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_expense_access!, only: [ :show, :edit, :update ]

  # GET /expenses
  def index
    @expenses = Expense
                  .joins(:payors)
                  .where("expenses.creator_id = ? OR users.id = ?", current_user.id, current_user.id)
                  .distinct
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # POST /expenses
  def create
    @expense = current_user.created_expenses.new(expense_params.except(:user_ids, :percentages))

    participant_ids = (expense_params[:user_ids]&.reject(&:blank?) || []) + [ current_user.id ]
    participant_ids.uniq.each do |id|
      @expense.expense_users.build(user_id: id)
    end

    if @expense.split_type == "percentage" && expense_params[:percentages].present?
      expense_params[:percentages].each do |user_id, percentage|
        @expense.expense_splits.build(
          user_id: user_id,
          percentage_split: percentage.to_f
        )
      end
    end

    if @expense.save
      redirect_to expenses_path, notice: "Expense created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end


  # GET /expenses/:id/edit
  def edit
    # @expense is already set by set_expense

    if @expense.user_group.blank?
        expense_user_ids = @expense.expense_users.pluck(:user_id)
        @selected_user_ids = User.where(id: expense_user_ids).pluck(:id)
    else
        @selected_user_ids = []
    end
  end

  def show
  end


  # PATCH/PUT /expenses/:id
  def update
    if @expense.update(expense_params.except(:user_ids, :percentages))

      @expense.expense_users.where.not(user_id: @expense.creator_id).destroy_all

      participant_ids = (expense_params[:user_ids]&.reject(&:blank?) || []) + [ @expense.creator_id ]

      participant_ids.uniq.each do |id|
        ExpenseUser.find_or_create_by!(user_id: id, expense_id: @expense.id)
      end

      if @expense.split_type == "percentage" && expense_params[:percentages].present?
        @expense.expense_splits.destroy_all

        expense_params[:percentages].each do |user_id, percentage|
          @expense.expense_splits.create!(
            user_id: user_id,
            percentage_split: percentage.to_f
          )
        end
      else
        @expense.expense_splits.destroy_all
      end

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

  def authorize_expense_access!
    unless @expense && (@expense.creator_id == current_user.id || @expense.users.include?(current_user))
      redirect_to expenses_path, alert: "Access denied."
    end
  end

  def set_expense
    @expense = Expense
                  .joins(:payors)
                  .where(id: params[:id])
                  .where("expenses.creator_id = :id OR users.id = :id", id: current_user.id)
                  .distinct
                  .first

    unless @expense
      redirect_to expenses_path, alert: "Access denied or expense not found."
    end
  end

  def expense_params
  params.require(:expense).permit(
    :title,
    :amount,
    :status,
    :split_type,
    :category_id,
    :user_group_id,
    user_ids: [],
    percentages: {}
  )
end

  def require_login
    redirect_to login_path, alert: "Please log in." unless current_user
  end
end
