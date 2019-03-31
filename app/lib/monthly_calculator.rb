class MonthlyCalculator
  attr_reader :budget_amount, :current_date

  def initialize(budget_amount, current_date)
    @budget_amount = budget_amount
    @current_date = current_date
  end

  def current_budget_amount
    daily_amount * current_date.day
  end

  # To get the remaining number of days in a month, we find the last day of the
  # month and then the next day (the first day of the next month) and subtract
  # the current day. This helps ensure we always have a non-zero number of days
  # left.
  #
  # > self.remaining_number_of_days_in_month(Date.new(2019, 3, 1))  # => 31
  # > self.remaining_number_of_days_in_month(Date.new(2019, 3, 31)) # =>  1
  def self.remaining_number_of_days_in_month(date)
    first_day_next_month = Date.new(date.year, date.month, -1) + 1
    (first_day_next_month - date).to_i
  end

  def daily_amount
    budget_amount / remaining_number_of_days_in_month
  end

  private

  def remaining_number_of_days_in_month
    self.class.remaining_number_of_days_in_month(current_date)
  end
end
