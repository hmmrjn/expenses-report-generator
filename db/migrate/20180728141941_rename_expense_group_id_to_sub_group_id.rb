class RenameExpenseGroupIdToSubGroupId < ActiveRecord::Migration[5.2]
  def change
    rename_column :expenses, :expense_group_id, :sub_group_id
  end
end
