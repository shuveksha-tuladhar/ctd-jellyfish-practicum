class DashboardController < ApplicationController 
    before_action :authenticate_user!

    def index 
        @user = current_user 
        # @groups = current_user.groups
        # @expenses = current_user.expenses.last(5)
    end 
end 
