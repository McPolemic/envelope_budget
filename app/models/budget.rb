class Budget < ApplicationRecord
  monetize :balance_cents
end
