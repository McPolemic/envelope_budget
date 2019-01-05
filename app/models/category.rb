class Category < ApplicationRecord
  belongs_to :budget

  monetize :balance_cents, :monthly_amount_cents
end
