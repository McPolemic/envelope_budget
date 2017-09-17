require 'date'
require 'minitest/autorun'

require './app/lib/message_parser'

describe MessageParser do
  describe "parses a message with only a dollar amount" do
    it "finds a dollar amount and gives a nil location" do
      parsed_message = MessageParser.parse("$15.23")

      parsed_message.amount.format.must_equal "$15.23"
      parsed_message.location.must_be_nil
      parsed_message.message.must_equal "$15.23"
    end
  end

  describe "parses a message with a dollar amount and location" do
    it "finds a dollar amount and location" do
      parsed_message = MessageParser.parse("$15 for Burger King")

      parsed_message.amount.format.must_equal "$15.00"
      parsed_message.location.must_equal "Burger King"
      parsed_message.message.must_equal "$15 for Burger King"
    end
  end
end
