require 'values'
require 'monetize'

class MessageParser
  Message = Value.new(:amount, :location, :message)

  def self.parse(message)
    raw_amount, _, raw_location = message.split(/ (for|at)* */, 2)
    amount = Monetize.parse(raw_amount)
    location = raw_location.gsub(/[!,.?]+$/, '') unless raw_location.nil?

    Message.new(amount, location, message)
  end
end

