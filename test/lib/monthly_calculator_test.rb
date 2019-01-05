require 'date'
require 'minitest/autorun'

require './app/lib/monthly_calculator'

describe MonthlyCalculator do
  describe "finding the number of days in a month" do
    it "has 28 days in February (usually)" do
      today = Date.new(2017, 2, 15)

      MonthlyCalculator.number_of_days_in_month(today).must_equal 28
    end

    it "has 31 days in January" do
      today = Date.new(2017, 1, 15)

      MonthlyCalculator.number_of_days_in_month(today).must_equal 31
    end
  end

  describe "your daily budget" do
    describe "on the first day of a 30-day month" do
      it "gives 1/30 of your budget" do
        today = Date.new(2017, 4, 1)
        calculator = MonthlyCalculator.new(300, today)

        calculator.current_budget_amount.must_equal 10
      end
    end
  end
end
