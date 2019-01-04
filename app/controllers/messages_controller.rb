class MessagesController < ApplicationController
  def create
    from_number = params['From']
    raw_message = params['Body']

    command, message = raw_message.split(' ', 2)
    command = command.downcase

    case command
    when "help", "setup"
      handle_setup(from_number)
    when "monthly", "budget"
      handle_monthly_budget_amount(from_number, message)
    when "balance"
      handle_balance(from_number, message)
    else
      handle_transaction(from_number, message)
    end
  end

  private
  def handle_setup(from_number)
    render plain: <<~EOF
      Set a monthly budget:
      MONTHLY $500 eating out

      Get all remaining balances:
      BALANCE

      Get the category balance:
      BALANCE groceries

      Sending transactions (amount and category):
      $12.23 eating out

      Questions, ask Adam
    EOF
  end
  
  def handle_monthly_budget_amount(from_number, message)
    message = MessageParser.parse(message)
    budget = budget_for_phone_number(from_number)
    category = budget.categories.find_or_create_by!(name: message.category)

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

  def handle_balance(from_number, message)
    message = MessageParser.parse(message)
    budget = budget_for_phone_number(from_number)
    category = budget.categories.find(name: message.category)

    response = if category
                 %q(Your balance for "#{category.name}" is currently #{category.balance.format}.)
               else
                 category_names = budget.categories.map(&:name).join(", ")

                 <<~EOF
                   "#{message.category}" not found!

                   Available categories: #{category_names}
                 EOF
               end

    render plain: response
  end

  def handle_transaction(from_number, message)
    budget = Budget.find_by(from_number: from_number)
    return render(plain: "Send SETUP for instructions on getting started.") if budget.nil?

    message = MessageParser.parse(message)

    logger.info %(Received message "#{message.message}" from #{from_number}")

    budget.balance -= message.amount
    budget.save!
    # Save transaction
    # Get total category amount from config
    # Get sum of transactions
    # balance = total - transaction_sum

    raise "Not implemeneted yet"

    response = "Neato! Your balance is now #{budget.balance.format}."
    logger.info %("Sending message \"#{response}\" to #{from_number}")

    render plain: response
  end

  def budget_for_phone_number(phone_number)
    budget = User.find_by!(phone_number: from_number).budget
  end
end
