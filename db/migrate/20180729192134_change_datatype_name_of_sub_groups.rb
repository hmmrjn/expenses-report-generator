class ChangeDatatypeNameOfSubGroups < ActiveRecord::Migration[5.2]
  def change
    change_column :sub_groups, :name, :string
  end
end
