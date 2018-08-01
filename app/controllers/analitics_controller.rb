class AnaliticsController < ApplicationController
  def index
    # categories doughnut chart
    @categories_array = []
    categories = Category.all
    categories.each do |category|
      sub_categories = SubCategory.where(category: category)
      expenses = Expense.where(sub_category: sub_categories)
      @categories_array.push({name: category.name, amount: expenses.sum(:amount)})
    end
    @categories_array.sort_by! {|row| row[:amount]}.reverse!

    # sub_categories doughnut chart
    @sub_categories_array = []
    sub_categories = SubCategory.all
    sub_categories.each do |sub_category|
      @sub_categories_array.push({name: sub_category.name, amount: sub_category.expenses.sum(:amount)})
    end
    @sub_categories_array.sort_by! {|row| row[:amount]}.reverse!
  end
end
