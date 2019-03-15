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
end
