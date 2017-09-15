class MessagesController < ApplicationController
  def create
    from_number = params['From']
    message = params['Body']

    command = message.split(' ').first.downcase
    case command
    when "setup"
      handle_setup(from_number)
    when "monthly"
      handle_monthly_budget_amount(from_number, message)
    else
      handle_transaction(from_number, message)
    end
  end

  private
  def handle_setup(from_number)
    render plain: <<~EOF
      Set a monthly budget:
      MONTHLY $500

      Sending transactions:
      $12.23 for Burger King

      Questions, ask Adam
    EOF
  end

  def handle_monthly_budget_amount(from_number, message)
    budget = Budget.find_or_create_by!(from_number: from_number)

    raw_amount = message.split(' ').last
    amount = Monetize.parse(raw_amount)

    budget.update_attributes!(balance: amount)

    render plain: "Groovy! Your balance is currently #{budget.balance.format}."
  end

  def handle_transaction(from_number, message)
    budget = Budget.find_by(from_number: from_number)
    return render(plain: "Send SETUP for instructions on getting started.") if budget.nil?

    message = MessageParser.parse(message)

    logger.info %(Received message "#{message.message}" from #{from_number}")

    budget.balance -= message.amount
    budget.save!

    response = "Neato! Your balance is now #{budget.balance.format}."
    logger.info %("Sending message \"#{response}\" to #{from_number}")

    render plain: response
  end
end
