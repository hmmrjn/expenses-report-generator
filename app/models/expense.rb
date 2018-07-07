class Expense < ApplicationRecord
  belongs_to :expense_group
  belongs_to :sub_category
  validates :date, :amount, :sub_category, presence: true
end
