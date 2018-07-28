class SubGroup < ApplicationRecord
  has_many :expenses, dependent: :destroy
  belongs_to :group
end
