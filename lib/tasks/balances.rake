namespace :balances do
  desc "Reset monthly category balances"
  task :monthly_reset => :environment do
    logger = Logger.new(STDOUT)

    Category.all.each do |category|
      category.update!(balance: category.monthly_amount)
      message = %Q(Your "#{category.name}" budget is now at #{category.balance.format}.)

      category.budget.users.each do |user|
        Messenger.send_message(user.phone_number,
                               message,
                               logger: logger) if user.notifications?
      end
    end
  end
end
