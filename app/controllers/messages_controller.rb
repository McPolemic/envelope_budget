class MessagesController < ApplicationController
  def create
    from_number = params['From']
    raw_message = params['Body']

    command, message = raw_message.split(' ', 2)
    command = command.downcase
    message = message.strip if message

    case command
    when "setup"
      handle_setup(from_number)
    when "monthly", "budget"
      handle_monthly_budget_amount(from_number, message)
    when "update"
      handle_notification_update(from_number, message)
    when "balance"
      handle_balance(from_number, message)
    else
      handle_transaction(from_number, raw_message)
    end
  end

  def handle_setup(from_number)
    render plain: <<~EOF
      Set a monthly budget:
      MONTHLY $500 Eating Out

      Monthly balance updates:
      UPDATE on/off

      Balance check:
      BALANCE

      Tracking amount and category:
      $12.23 eating out
    EOF
  end
  
  def handle_monthly_budget_amount(from_number, message)
    message = MessageParser.parse(message)
    budget = budget_for_phone_number(from_number)
    category = budget.find_category(message.category)
    category ||= Category.create!(budget: budget, name: message.category)

    # If we're updating a category that already had transactions, let's carry
    # over the difference
    balance = if category.balance != 0
      difference = category.monthly_amount - category.balance
      message.amount - difference
    else
      message.amount
    end

    category.update!(monthly_amount: message.amount, balance: balance)

    render plain: "Groovy! Your balance is currently #{balance.format}."
  end

  def handle_balance(from_number, category_name)
    budget = budget_for_phone_number(from_number)

    categories = if category_name
                   [budget.find_category(category_name)]
                 else
                   budget.categories.order(:name)
                 end

    response = categories.map do |category|
      "#{category.name}: #{category.balance.format} (#{category.remaining_per_day.format} per day)"
    end.join("\n")

    render plain: response
  end

  def handle_transaction(from_number, message)
    budget = budget_for_phone_number(from_number)
    return render(plain: "Send SETUP for instructions on getting started.") if budget.nil?

    logger.info %(Received message "#{message}" from #{from_number}")
    message = MessageParser.parse(message)
    category = budget.categories.where('lower(name) = ?', message.category.downcase).first
    logger.info( %Q(Current balance for "#{category.name}": #{category.balance}) )

    category.update!(balance: category.balance - message.amount)

    daily_amount = MonthlyCalculator.new(category.balance, Date.today).daily_amount

    response = <<~EOF.strip
      Your "#{category.name}" balance is now #{category.balance.format}.

      That's #{daily_amount.format} per day for the rest of the month.
    EOF

    # Send transaction results to all users on a budget
    budget.users.each do |user|
      Messenger.send_message(user.phone_number, response, logger: Rails.logger)
    end

    render plain: ''
  end

  def handle_notification_update(phone_number, message)
    user = User.find_by(phone_number: phone_number)


    notify = case message.split(' ').last.downcase
             when "on", "enable", "yes"
               true
             when "off", "disable", "no"
               false
             else
               :invalid
             end

    return render(plain: <<~EOF) if notify == :invalid
      Error: Could not parse messages.
      To enable balance updates, send "updates on".
      To disable balance updates, send "updates off".
      EOF

    user.update_attributes!(notifications: notify)

    render(plain: "Daily budget updates have been turned #{notify ? 'on' : 'off'}.")
  end

  def budget_for_phone_number(from_number)
    user = User.find_by(phone_number: from_number)

    user.budget if user.present?
  end
end
