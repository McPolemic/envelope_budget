class CreateBudgets < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.string :from_number
      t.monetize :balance

      t.timestamps
    end
  end
end
