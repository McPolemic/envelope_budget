require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Budget.create!(from_number: "+11234567890",
                   balance: Money.new(500_00, "USD"))
  end

  test "receiving a transaction from a known number" do
    params = {
      'From' => '+11234567890',
      'Body' => '$15 for Burger King'
    }

    post messages_url, params: params

    assert_match /\$485\.00/, response.body
  end

  test "receiving a transaction from an unknown number" do
    params = {
      'From' => '+19999999999',
      'Body' => '$15 for Burger King'
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
      'From' => '+15553334444',
      'Body' => 'Monthly   $100'
    }

    post messages_url, params: params
    budget = Budget.find_by(from_number: '+15553334444')

    assert_equal budget.balance.format, '$100.00'
    assert_match /\$100\.00/, response.body
  end
end
