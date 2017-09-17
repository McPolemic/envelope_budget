class Budget < ApplicationRecord
  monetize :balance_cents, :monthly_amount_cents
end
