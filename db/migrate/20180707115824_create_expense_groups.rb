class CreateExpenseGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_groups do |t|
      t.string :name
      t.timestamps
    end
  end
end
