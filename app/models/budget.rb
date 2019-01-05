class Budget < ApplicationRecord
  has_many :users
  has_many :categories

  def find_category(category_name)
    categories.where('lower(name) = ?', category_name.downcase).first
  end
end
