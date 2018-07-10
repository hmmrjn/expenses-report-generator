class AddExprenseGroupToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_reference :expenses, :expense_group
  end
end
