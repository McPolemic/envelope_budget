class AddMonthlyAmountToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_monetize :budgets, :monthly_amount
  end
end
