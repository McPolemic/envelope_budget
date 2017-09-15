class MessagesController < ApplicationController
  def create
    balance = Money.new(1000_00, :usd)
    from_number = params['From']
    message = params['Body']

    message = MessageParser.parse(message)

    logger.info("Received message \"#{message.message}\" from #{from_number}")

    balance -= message.amount

    response = "Neato! Your balance is now #{balance.format}."
    logger.info("Sending message \"#{response}\" to #{from_number}")

    render plain: response
  end
end
