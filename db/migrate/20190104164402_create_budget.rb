class CreateBudget < ActiveRecord::Migration[5.2]
  def change
    create_table :budgets do |t|
      t.string :name
    end
  end
end
