class Transaction < ApplicationRecord
  HORRIBLE_NO_GOOD_HARDCODED_TIMEZONE = "Eastern Time (US & Canada)"

  belongs_to :category

  monetize :amount_cents

  def localized_datetime
    datetime.
      in_time_zone(HORRIBLE_NO_GOOD_HARDCODED_TIMEZONE).
      to_formatted_s(:db)
  end

  def from_name
    user = User.find_by(phone_number: from)
    if user
      user.name
    else
      from
    end
  end
end
