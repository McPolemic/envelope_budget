class Budget < ApplicationRecord
  def add_daily_budget_amount!(date = Date.today)
    calc = MonthlyCalculator.new(monthly_amount, date)
    new_balance = balance + calc.daily_amount
    update_attributes!(balance: new_balance)
  end

  def notify_on_balance_updates?
    notify_on_balance_updates
  end

  monetize :balance_cents, :monthly_amount_cents
end
