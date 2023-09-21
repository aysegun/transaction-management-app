class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.decimal :amount
      t.text :description
      t.date :date
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
