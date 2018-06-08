class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.date :date
      t.references :sub_category, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
