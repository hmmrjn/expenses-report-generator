class AnaliticsController < ApplicationController
  def index
    sub_categories = SubCategory.all
    @array = []
    sub_categories.each do |sub_category|
      @array.push({name: sub_category.name, amount: sub_category.expenses.sum(:amount)})
    end
    @array.sort_by! {|row| row[:amount]}.reverse!
  end
end
