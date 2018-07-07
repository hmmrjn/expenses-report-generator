class ExpenseGroup < ApplicationRecord
  has_many :expense, dependent: :destroy
end
