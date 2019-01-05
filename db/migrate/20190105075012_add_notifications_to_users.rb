class AddNotificationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notifications, :boolean
  end
end
