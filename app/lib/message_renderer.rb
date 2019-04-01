class MessageRenderer
  def self.setup
    <<~EOF
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

  def self.monthly_budget_amount(balance)
    "Groovy! Your balance is currently #{balance.format}."
  end

  def self.update_notifications(notify)
    "Daily budget updates have been turned #{notify ? 'on' : 'off'}."
  end

  def self.balances(categories)
    total = Category.new(name: "Total",
                         balance_cents: categories.map(&:balance_cents).sum)
    display_categories = categories.dup + [total]
    display_categories.map { |category| balance(category) }.join("\n")
  end

  def self.balance(category)
    name = category.name
    balance = category.balance.format
    remaining_per_day = category.remaining_per_day.format

    if category.balance >= 0
      "#{name}: #{balance} (#{remaining_per_day} per day)"
    else
      "#{name}: #{balance}"
    end
  end

  def self.unknown_category_response(category_name:, categories:)
    response = <<~EOF
      Invalid category "#{category_name}".

      Valid categories:
    EOF

    category_list = categories.map do |category|
      "* #{category.name}"
    end
      
    response + category_list.join("\n")
  end

  def self.transaction(category:, daily_amount:)
    template = <<~EOF
      Your "<%= category.name %>" balance is now <%= category.balance.format %>.

      <% if daily_amount > 0 %>
      That's <%= daily_amount.format %> per day for the rest of the month.
      <% end %>
    EOF

    ERB.new(template, nil, '>')
       .result_with_hash(category: category,
                         daily_amount: daily_amount)
  end

  def self.invalid_notification_update
    <<~EOF
      Error: Could not parse messages.
      To enable balance updates, send "updates on".
      To disable balance updates, send "updates off".
    EOF
  end
end
