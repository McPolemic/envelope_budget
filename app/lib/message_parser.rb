require 'values'
require 'monetize'

class MessageParser
  Message = Value.new(:amount, :category)

  def self.parse(message)
    raw_amount, raw_category = message.match(/(\$*[\d.]+)(.*)/)[1..2]
    amount = Monetize.parse(raw_amount)
    category = category.strip

    Message.new(amount, category)
  end
end

