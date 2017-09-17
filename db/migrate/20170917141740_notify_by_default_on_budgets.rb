class NotifyByDefaultOnBudgets < ActiveRecord::Migration[5.1]
  class Budget < ApplicationRecord; end

  def change
    change_column :budgets, :notify_on_balance_updates, :boolean, :default => true

    Budget.all.each do |budget|
      budget.update_attributes!(notify_on_balance_updates: true)
    end
  end
end
