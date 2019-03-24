class Category < ApplicationRecord
  belongs_to :budget
  has_many :transactions

  monetize :balance_cents, :monthly_amount_cents

  def remaining_per_day
    MonthlyCalculator.new(balance, Date.today).daily_amount
  end
end
