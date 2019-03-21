class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show]

  def show
    @categories = @budget.categories
    p @categories
  end

  private
    def set_budget
      @budget = Budget.find(params[:id])
    end
end
