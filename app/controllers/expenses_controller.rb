require 'csv'

class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  before_action :set_expenses, only: [:index, :download, :download_csv, :download_excel]

  # GET /expenses
  def index
    @sub_categories = SubCategory.all.order(:name)
  end

  # GET /expenses/1
  def show
  end

  # GET /expenses/new
  def new
    @today = Date.today
    @expense = Expense.new
    @sub_categories = SubCategory.all
  end

  # GET /expenses/1/edit
  def edit
    @sub_categories = SubCategory.all
    @sub_groups = SubGroup.all
  end

  # POST /expenses
  #TODO refactoring
  def create
    @expense = Expense.new(expense_params)
    @expense.date = @expense.date.change(day: params[:expense][:day].to_i)
    session[:last_date] = @expense.date

    # for renders
    @last_date = session[:last_date]
    @expenses = Expense.all.order(date: :desc)
    @sub_categories = SubCategory.all
    @sub_group = SubGroup.find(params[:expense][:sub_group_id])

    # if new subcat, ask for cat name
    subcat_na = params[:expense][:sub_category_name]
    cat_na = params[:expense][:category_name]
    if subcat_na.present? && !cat_na.present? && !SubCategory.exists?(name: subcat_na.downcase)
      @unregistered_sub_category = true
      @sub_category_name = subcat_na
      @categories = Category.all
      render 'sub_groups/show'
      return
    end

    # create subcat. create cat too if missing
    if subcat_na.present? && cat_na.present?
      unless Category.exists?(name: cat_na.downcase)
        Category.create(name: cat_na.downcase)
      end
      category = Category.find_by(name: cat_na.downcase)
      sub_category = category.sub_categories.create(name: subcat_na.downcase)
      @expense.sub_category = sub_category
    end

    if @expense.save
      redirect_to @sub_group, notice: 'Expense was successfully created.'
    else
      render 'sub_groups/show'
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      redirect_to @expense.sub_group, notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy
    redirect_to expenses_url, notice: 'Expense was successfully destroyed.'
  end

  #GET expenses/download_csv
  def download_csv
    header = ['Date', 'Category', 'Amount', 'Sub Category']
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      @expenses.each do |expense|
        csv << [expense.date, expense.sub_category.category.name.upcase, expense.amount, expense.sub_category.name.titleize]
      end
    end
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: "every-expense-till-#{@expenses.last.date.strftime("%Y-%m")}.csv",
      type: 'text/csv; charset=uft-8'
  end

  # GET /expenses/download_excel
  def download_excel
    book = RubyXL::Workbook.new
    sheet = book[0]
    @expenses.each_with_index do |expense, i|
      c = sheet.add_cell(i, 0)
      c.set_number_format('yyyy/m/d')
      c.change_contents(expense.date)
      sheet.add_cell(i, 1, expense.sub_category.category.name.upcase)
      c = sheet.add_cell(i, 2, expense.amount)
      c.set_number_format("[$¥-ja-JP]* #,###")
      sheet.add_cell(i, 3, expense.sub_category.name.titleize)
    end
    send_data book.stream.read,
      type: 'application/excel',
      filename: "every-expense-till-#{@expenses.last.date.strftime("%Y-%m")}.xlsx"
  end

  # GET /expenses/download_sum_excel
  def download_sums_excel
    book = RubyXL::Workbook.new
    sheet = book[0]
    @sub_catgories = SubCategory.all.order(:name)
    lastest_i = nil
    @sub_catgories.each_with_index do |sub_category, i|
      sheet.add_cell(i, 0, sub_category.date_span)
      sheet.add_cell(i, 1, sub_category.category.name.upcase)
      c = sheet.add_cell(i, 2, sub_category.expenses.sum(:amount))
      c.set_number_format("[$¥-ja-JP]* #,###")
      sheet.add_cell(i, 3, sub_category.name.titleize)
      lastest_i = i
    end
    sheet.add_cell(lastest_i+1, 0, 'Total')
    c = sheet.add_cell(lastest_i+1, 2, '', "SUM(C1:C#{lastest_i+1})")
    c.set_number_format("[$¥-ja-JP]* #,###")
    @expenses = Expense.all.order(:date)
    send_data book.stream.read,
      type: 'application/excel',
      filename: "every-expense-sums-till-#{@expenses.last.date.strftime("%Y-%m")}.xlsx"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_expenses
      @expenses = Expense.all.joins(sub_category: :category).order(:date, 'categories.name', 'sub_categories.name', :amount)
    end

    # Only allow a trusted parameter "white list" through.
    def expense_params
      if params[:expense][:sub_category_name]
        if subcat = SubCategory.find_by(name: params[:expense][:sub_category_name])
          params[:expense][:sub_category_id] = subcat.id
        end
      end
      params.require(:expense).permit(:date, :sub_category_id, :amount, :sub_group_id)
    end
end
