class User < ApplicationRecord
  belongs_to :budget

  def notifications?
    notifications
  end
end
