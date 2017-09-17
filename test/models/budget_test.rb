require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  test "adding the daily budget amount" do
    b = Budget.create!(balance: 0, monthly_amount: 300)
    date = Date.new(2017, 4, 15)

    b.add_daily_budget_amount!(date)

    assert_equal(b.balance.format, "$10.00")
  end
end
