require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # 10 days left in the month
    travel_to Time.new(2019, 1, 22, 12, 00, 00)
  end

  test "a positive balance shows the remaining amount per day" do
    positive_category = Category.new(name: "Groceries", balance: Money.new(12_34, "USD"))

    expected = "Groceries: $12.34 ($1.23 per day)"
    assert_equal expected, MessageRenderer.balance(positive_category)
  end

  test "a negative balance just shows the balance" do
    negative_category = Category.new(name: "Eating Out", balance: Money.new(-45_67, "USD"))

    expected = "Eating Out: $-45.67"
    assert_equal expected, MessageRenderer.balance(negative_category)
  end

  test "listing all balances shows per-day for positive balances" do
    positive_category = Category.new(name: "Groceries", balance: Money.new(12_34, "USD"))
    negative_category = Category.new(name: "Eating Out", balance: Money.new(-45_67, "USD"))
    categories = [positive_category, negative_category]

    expected = <<~EOF.strip
      Groceries: $12.34 ($1.23 per day)
      Eating Out: $-45.67
      Total: $-33.33
    EOF
    assert_equal expected, MessageRenderer.balances(categories)
  end
end
