class MessagesController < ApplicationController
  def create
    from_number = params['From']
    message = params['Body']

    command = message.split(' ').first.downcase
    case command
    when "setup"
      handle_setup(from_number)
    when "monthly", "budget"
      handle_monthly_budget_amount(from_number, message)
    when "update"
      handle_notification_update(from_number, message)
    else
      handle_transaction(from_number, message)
    end
  end

  private
  def handle_setup(from_number)
    render plain: <<~EOF
      Set a monthly budget:
      MONTHLY $500

      Daily balance updates:
      UPDATE on/off

      Sending transactions:
      $12.23 for Burger King

      Questions, ask Adam
    EOF
  end

  def handle_monthly_budget_amount(from_number, message)
    budget = Budget.find_or_create_by!(from_number: from_number)

    raw_amount = message.split(' ').last
    amount = Monetize.parse(raw_amount)

    calculator = MonthlyCalculator.new(amount, Date.today)
    adjusted_amount = calculator.current_budget_amount

    budget.update_attributes!(balance: adjusted_amount,
                              monthly_amount: amount)

    render plain: "Groovy! Your balance is currently #{budget.balance.format}."
  end

  def handle_notification_update(from_number, message)
    budget = Budget.find_by(from_number: from_number)


    notify = case message.split(' ').last.downcase
             when "on", "enable"
               true
             when "off", "disable"
               false
             else
               :invalid
             end

    return render(plain: <<~EOF) if notify == :invalid
      Error: Could not parse messages.
      To enable daily budget updates, send "update on".
      To disable daily budget updates, send "update off".
      EOF

    budget.update_attributes!(notify_on_balance_updates: notify)

    render(plain: "Daily budget updates have been turned #{notify ? 'on' : 'off'}.")
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
