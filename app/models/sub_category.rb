class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :expenses
  validates :name, :category, presence: true

  # returns something like this: 03/24-05/30/2018
  # pass the group_id to look only for the expenses of a specific group
  def date_span(group_id=nil)
    expenses = self.expenses
    if group_id
      sub_groups = SubGroup.where(group_id: group_id)
      expenses = expenses.where(sub_group: sub_groups)
    end
    d1 = expenses.order(:date).first.date
    d2 = expenses.order(:date).last.date
    d2_format = (d1.month == d2.month)? ((d1.day == d2.day)? '/%Y' : '-%d/%Y') : '-%m/%d/%Y'
    d1.strftime('%m/%d') + d2.strftime(d2_format)
  end
end
