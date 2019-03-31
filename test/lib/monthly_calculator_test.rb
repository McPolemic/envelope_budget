require 'date'
require 'minitest/autorun'

require './app/lib/monthly_calculator'

describe MonthlyCalculator do
  describe "finding the remaining number of days in a month" do
    it "January has 31 days remaining on the 1st" do
      today = Date.new(2017, 1, 1)

      MonthlyCalculator.remaining_number_of_days_in_month(today).must_equal 31
    end

    it "1 day remaining on last day of the month" do
      today = Date.new(2017, 1, 31)

      MonthlyCalculator.remaining_number_of_days_in_month(today).must_equal 1
    end

    it "The middle of the month does not count the current day as a full day" do
      today = Date.new(2017, 2, 15)

      # The 15th day counts as a day,
      # so there are 13 days remaining plus the current day = 14
      MonthlyCalculator.remaining_number_of_days_in_month(today).must_equal 14
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
