require 'csv'

class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  def index
    @expenses = Expense.all.order(date: :desc)
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
    @expense_group = ExpenseGroup.find(params[:expense][:expense_group_id])

    # if new subcat, ask for cat name
    subcat_na = params[:expense][:sub_category_name]
    cat_na = params[:expense][:category_name]
    if subcat_na.present? && !cat_na.present? && !SubCategory.exists?(name: subcat_na.downcase)
      @unregistered_sub_category = true
      @sub_category_name = subcat_na
      @categories = Category.all
      render 'expense_groups/show'
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
      redirect_to @expense_group, notice: 'Expense was successfully created.'
    else
      render 'expense_groups/show'
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy
    redirect_to expenses_url, notice: 'Expense was successfully destroyed.'
  end

  # DELETE /expenses/
  def destroy_all
    Expense.destroy_all
    redirect_to expenses_url, notice: 'Expenses were successfully destroyed.'
  end

  def download
    @expenses = Expense.all.order(:date)
    header = ['Date', 'Category', 'Amount', 'Sub Category']
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      @expenses.each do |expense|
        csv << [expense.date, expense.sub_category.category.name.upcase, expense.amount, expense.sub_category.name.titleize]
      end
    end
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: "expenses-#{@expenses.last.date.strftime("%Y-%m")}.csv",
      type: 'text/csv; charset=uft-8'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def expense_params
      if params[:expense][:sub_category_name]
        if subcat = SubCategory.find_by(name: params[:expense][:sub_category_name])
          params[:expense][:sub_category_id] = subcat.id
        end
      end
      params.require(:expense).permit(:date, :sub_category_id, :amount, :expense_group_id)
    end
end
