require 'csv'

class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  def index
    if session[:current_day]
      @current_day = 1
    else
      @current_day = session[:current_day]
    end
    @expense = Expense.new
    @expenses = Expense.all.order(date: :desc)
    @sub_categories = SubCategory.all
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
  def create
    session[:current_day] = params[:expense]['date(3i)']
    @current_day = session[:current_day]
    @expense = Expense.new(expense_params)
    @sub_categories = SubCategory.all
    if @expense.save
      redirect_to expenses_path, notice: 'Expense was successfully created.'
    else
      @expenses = Expense.all.order(date: :desc)
      render :index
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

  def download
    @expenses = Expense.all.order(:date)
    header = ['Date', 'Category', 'Sub Category', 'Amount']
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      @expenses.each do |expense|
        csv << [expense.date, expense.sub_category.category.name, expense.sub_category.name, expense.amount]
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
        subcat = SubCategory.find_by(name: params[:expense][:sub_category_name])
        params[:expense][:sub_category_id] = subcat.id
      end
      params.require(:expense).permit(:date, :sub_category_id, :amount)
    end
end
