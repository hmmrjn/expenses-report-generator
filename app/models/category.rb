class Category < ApplicationRecord
  has_many :sub_categories, dependent: :delete_all
  validates :name, presence: true
end
