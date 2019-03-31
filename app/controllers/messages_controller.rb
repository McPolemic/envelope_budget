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
    render plain: MessageRenderer.setup
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

    render plain: MessageRenderer.monthly_budget_amount(balance)
  end

  def handle_balance(from_number, category_name)
    budget = budget_for_phone_number(from_number)

    response = if category_name.present?
                 logger.info( %Q(Showing balance for "#{category_name}" to #{from_number} ))
                 category = budget.find_category(category_name)
                 MessageRenderer.balance(category)
               else
                 categories = budget.categories.order(:name)
                 MessageRenderer.balances(categories)
               end

    render plain: response
  end

  def handle_transaction(from_number, message)
    budget = budget_for_phone_number(from_number)
    return render(plain: "Send SETUP for instructions on getting started.") if budget.nil?

    logger.info %(Received message "#{message}" from #{from_number}")
    message = MessageParser.parse(message)
    category = budget.categories.where('lower(name) = ?', message.category.downcase).first

    if category.nil?
      response = MessageRenderer.unknown_category_response(category_name: message.category,
                                                           categories: budget.categories)
      return render plain: response
    end

    logger.info( %Q(Current balance for "#{category.name}": #{category.balance}) )

    category.transactions.create!(amount: message.amount, datetime: Time.now.utc, from: from_number)
    category.update!(balance: category.balance - message.amount)

    daily_amount = MonthlyCalculator.new(category.balance, Date.today).daily_amount
    response = MessageRenderer.transaction(category: category,
                                           daily_amount: daily_amount)

    logger.info( %Q(New balance for "#{category.name}": #{category.balance}) )

    # Send transaction results to all users on a budget
    budget.users.each do |user|
      Messenger.send_message(user.phone_number, response.strip, logger: Rails.logger)
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
               return render(plain: MessageRenderer.invalid_notification_update)
             end

    user.update_attributes!(notifications: notify)

    response = MessageRenderer.update_notifications(notify)
    render(plain: response)
  end

  def budget_for_phone_number(from_number)
    user = User.find_by(phone_number: from_number)

    user.budget if user.present?
  end
end
