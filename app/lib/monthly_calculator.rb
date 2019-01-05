class MonthlyCalculator
  attr_reader :budget_amount, :current_date

  def initialize(budget_amount, current_date)
    @budget_amount = budget_amount
    @current_date = current_date
  end

  def current_budget_amount
    daily_amount * current_date.day
  end

  # Get the last day of the current month
  def self.number_of_days_in_month(date)
    Date.new(date.year, date.month, -1).day
  end

  def self.remaining_number_of_days_in_month(date)
    (Date.new(date.year, date.month, -1) - date).to_i
  end

  def daily_amount
    budget_amount / remaining_number_of_days_in_month
  end

  private

  def remaining_number_of_days_in_month
    self.class.remaining_number_of_days_in_month(current_date)
  end
end
