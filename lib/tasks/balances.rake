namespace :balances do
  desc "Add daily budget amount to all budgets and send a balance update"
  task :update => :environment do
    Budget.all.each do |budget|
      budget.add_daily_budget_amount!
      Messenger.send_message(budget.from_number,
                             "Good morning! Your budget is now #{budget.balance.format}.")
    end
  end
end
