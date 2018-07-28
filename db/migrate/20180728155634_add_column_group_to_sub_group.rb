class AddColumnGroupToSubGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :sub_groups, :group
  end
end
