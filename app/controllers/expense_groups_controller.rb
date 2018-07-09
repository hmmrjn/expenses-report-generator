class ExpenseGroupsController < ApplicationController
  before_action :set_expense_group, only: [:show, :edit, :update, :destroy, :destroy_all_expenses, :download]

  # GET /expense_groups
  def index
    @expense_groups = ExpenseGroup.all
  end

  # GET /expense_groups/1
  def show
    if session[:last_date]
      @last_date = session[:last_date].to_date
    else
      @last_date = Date.today.change(day: 1)
    end

    @expense = Expense.new
    @expenses = Expense.all.order(date: :desc)
    @sub_categories = SubCategory.all
  end

  # GET /expense_groups/new
  def new
    @expense_group = ExpenseGroup.new
  end

  # GET /expense_groups/1/edit
  def edit
  end

  # POST /expense_groups
  def create
    @expense_group = ExpenseGroup.new(expense_group_params)

    if @expense_group.save
      redirect_to @expense_group, notice: 'Expense group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /expense_groups/1
  def update
    if @expense_group.update(expense_group_params)
      redirect_to @expense_group, notice: 'Expense group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /expense_groups/1
  def destroy
    @expense_group.destroy
    redirect_to expense_groups_url, notice: 'Expense group was successfully destroyed.'
  end

  # DELETE expense_groups/:id/expenses
  def destroy_all_expenses
    @expense_group.expenses.destroy_all
    redirect_to @expense_group, notice: 'Expenses were successfully destroyed.'
  end

  # GET expense_groups/1/download
  def download
    @expenses = Expense.where(expense_group_id: params[:id]).order(:date)
    header = ['Date', 'Category', 'Amount', 'Sub Category']
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      @expenses.each do |expense|
        csv << [expense.date, expense.sub_category.category.name.upcase, expense.amount, expense.sub_category.name.titleize]
      end
    end
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: "expenses-#{@expenses.last.date.strftime("%Y-%m")}-#{@expense_group.name}.csv",
      type: 'text/csv; charset=uft-8'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_group
      @expense_group = ExpenseGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def expense_group_params
      params.require(:expense_group).permit(:name)
    end
end
