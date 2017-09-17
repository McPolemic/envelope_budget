class MonthlyCalculator
  attr_reader :budget_amount, :current_date

  def initialize(budget_amount, current_date)
    @budget_amount = budget_amount
    @current_date = current_date
  end

  def current_budget_amount
    daily_amount * current_date.day
  end

  def self.number_of_days_in_month(date)
    year = date.year
    next_month = date.month

    Date.new(year, next_month, -1).day
  end

  def daily_amount
    budget_amount / number_of_days_in_month
  end

  private

  def number_of_days_in_month
    self.class.number_of_days_in_month(current_date)
  end
end
