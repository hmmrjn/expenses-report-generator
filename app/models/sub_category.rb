class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :expenses
  validates :name, :category, presence: true

  def date_span
    d1 = self.expenses.order(:date).first.date
    d2 = self.expenses.order(:date).last.date
    d2_format = (d1.month == d2.month)? ((d1.day == d2.day)? '/%Y' : '-%d/%Y') : '-%m/%d/%Y'
    d1.strftime('%m/%d') + d2.strftime(d2_format)
  end
end
