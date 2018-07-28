class Group < ApplicationRecord
  has_many :sub_groups, dependent: :destroy
end
