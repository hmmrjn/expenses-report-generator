class RenameExpenseGroupToSubGroup < ActiveRecord::Migration[5.2]
  def change
    rename_table :expense_groups, :sub_groups
  end
end
