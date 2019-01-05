require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    budget = Budget.create!(name: "test budget")
    User.create!(budget: budget,
                 phone_number: '+11234567890')
    Category.create!(budget: budget,
                     name: 'Eating Out',
                     balance: Money.new(500_00, "USD"))

    Category.create!(budget: budget,
                     name: 'Groceries',
                     balance: Money.new(1000_00, "USD"))
  end

  test "receiving a transaction from a known number" do
    params = {
      'From' => '+11234567890',
      'Body' => '$15 eating out'
    }

    post messages_url, params: params

    assert_match /\$485\.00/, response.body
  end

  test "receiving a transaction from an unknown number" do
    params = {
      'From' => '+19999999999',
      'Body' => '$15 eating out'
    }

    post messages_url, params: params

    assert_match /Send SETUP for instructions on getting started./, response.body
  end

  test "getting setup info" do
    params = {
      'From' => '+11234567890',
      'Body' => 'SETUP'
    }

    post messages_url, params: params

    assert_match /Set a monthly budget/, response.body
    assert_operator response.body.length, :<, 160
  end

  test "setting a monthly budget amount" do
    params = {
      'From' => '+11234567890',
      'Body' => 'Monthly   $100 eating out'
    }

    post messages_url, params: params

    budget = User.find_by(phone_number: '+11234567890').budget
    category = Category.find_by(budget: budget, name: 'Eating Out')

    assert_equal category.monthly_amount.format, '$100.00'
  end

  test 'get a balance for a specific category' do
    params = {
      'From' => '+11234567890',
      'Body' => 'Balance eating out'
    }

    post messages_url, params: params

    assert_match /\$500\.00/, response.body
  end

  test 'get all balances for a budget' do
    params = {
      'From' => '+11234567890',
      'Body' => 'Balance'
    }

    post messages_url, params: params

    expected = <<~EOF.strip
      Eating Out: $500.00
      Groceries: $1,000.00
    EOF

    assert_equal expected, response.body
  end

  test "enabling balance notifications" do
    phone_number = '+11234567890'
    params = {
      'From' => phone_number,
      'Body' => 'update on'
    }

    post messages_url, params: params

    user = User.find_by(phone_number: phone_number)

    assert_equal user.notifications?, true
    assert_match /turned on/, response.body
  end

  test "disabling balance notifications" do
    phone_number = '+11234567890'
    params = {
      'From' => phone_number,
      'Body' => 'update off'
    }

    post messages_url, params: params

    user = User.find_by(phone_number: phone_number)

    assert_equal user.notifications?, false
    assert_match /turned off/, response.body
  end
end
