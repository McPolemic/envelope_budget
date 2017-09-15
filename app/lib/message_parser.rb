require 'values'
require 'monetize'

class MessageParser
  Message = Value.new(:amount, :location, :message)

  def self.parse(message)
    raw_amount, _, raw_location = message.split(/ (at|for) /, 2)
    amount = Monetize.parse(raw_amount)
    location = raw_location.gsub(/[!,.?]+$/, '')

    Message.new(amount, location, message)
  end
end

