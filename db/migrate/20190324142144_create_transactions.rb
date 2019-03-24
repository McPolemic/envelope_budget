class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :category_id
      t.integer :amount_cents
      t.datetime :datetime
      t.string :from
      t.string :description

      t.timestamps
    end
  end
end
