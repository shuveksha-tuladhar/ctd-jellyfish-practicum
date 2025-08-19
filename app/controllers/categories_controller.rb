class CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: [:destroy ]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: "Category deleted successfully."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_login
    redirect_to login_path, alert: "Please log in." unless current_user
  end
end
