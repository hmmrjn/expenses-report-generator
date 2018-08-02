class AnaliticsController < ApplicationController
  def index
    # categories all periods statistics doughnut chart
    @categories_array = []
    categories = Category.all
    categories.each do |category|
      sub_categories = SubCategory.where(category: category)
      expenses = Expense.where(sub_category: sub_categories)
      @categories_array.push({name: category.name, amount: expenses.sum(:amount)})
    end
    @categories_array.sort_by! {|row| row[:amount]}.reverse!

    # sub_categories all periods statistics doughnut chart
    @sub_categories_array = []
    sub_categories = SubCategory.all
    sub_categories.each do |sub_category|
      @sub_categories_array.push({name: sub_category.name, amount: sub_category.expenses.sum(:amount)})
    end
    @sub_categories_array.sort_by! {|row| row[:amount]}.reverse!

    # sub_categories periodical statistics column chart
    @montly_amounts_array = prepare_montly_amounts_array
  end

  private
    # retruns => [{:month=>"05", :amounts=>[25000, 0,.., 800]}, {:month=>"06", :amounts=>[147730, 48760,.., 2210], ...}
    def prepare_montly_amounts_array
      @sub_category_names = Expense.joins(:sub_category).group('sub_categories.name').order('sum_amount DESC').sum(:amount).keys
      # => {"pasmo charge"=>277870, "shinkansen"=>171860, "japanese class"=>138100, "
      # TODO strftime() works only on SQLite
      query_result = Expense.all.joins(:sub_category).group('strftime("%m", date)').group('sub_categories.name').sum('amount')
      month_last = query_result.first[0][0] # query_result.first => [["03", "business meal (1)"], 4352]
      result_array = []
      temp_array = Array.new(@sub_category_names.length).fill(0)
      query_result.each do |month_subcat_array, amount|
        if month_last != month_subcat_array[0]
          result_array << {month: month_last, amounts: temp_array}
          temp_array = Array.new(@sub_category_names.length).fill(0)
        end
        @sub_category_names.each_with_index do |sub_category_name, i|
          temp_array[i] = amount if sub_category_name == month_subcat_array[1]
        end
        month_last = month_subcat_array[0]
      end
      result_array << {month: month_last, amounts: temp_array}
      return result_array
    end

end
