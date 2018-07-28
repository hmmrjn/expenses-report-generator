class SubGroup < ApplicationRecord
  has_many :expenses, dependent: :destroy
end
