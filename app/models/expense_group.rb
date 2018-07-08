class ExpenseGroup < ApplicationRecord
  has_many :expenses, dependent: :destroy
end
