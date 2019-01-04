class CreateCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.monetize :balance
      t.monetize :monthly_amount
      t.string :name
      t.references :budget
    end
  end
end
