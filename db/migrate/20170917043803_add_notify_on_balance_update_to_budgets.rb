class AddNotifyOnBalanceUpdateToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column(:budgets, :notify_on_balance_updates, :boolean)
  end
end
