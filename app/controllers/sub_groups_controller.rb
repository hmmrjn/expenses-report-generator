require 'csv'

class SubGroupsController < ApplicationController
  before_action :set_sub_group, only: [:show, :edit, :update, :destroy, :destroy_all_expenses, :download, :download_excel]

  # GET /sub_groups
  def index
    @sub_groups = SubGroup.all
  end

  # GET /sub_groups/1
  def show
    if session[:last_date]
      @last_date = session[:last_date].to_date
    else
      @last_date = Date.today.change(day: 1)
    end

    @expense = Expense.new
    @expenses = @sub_group.expenses.order({date: :desc, id: :desc})
    @sub_categories = SubCategory.all
  end

  # GET /sub_groups/new
  def new
    @sub_group = SubGroup.new
    @sub_group.group_id = params[:group_id] if params[:group_id]
    @groups = Group.all
  end

  # GET /sub_groups/1/edit
  def edit
    @groups = Group.all
  end

  # POST /sub_groups
  def create
    @sub_group = SubGroup.new(sub_group_params)

    if @sub_group.save
      redirect_to @sub_group, notice: 'Sub group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sub_groups/1
  def update
    if @sub_group.update(sub_group_params)
      redirect_to @sub_group, notice: 'Sub group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sub_groups/1
  def destroy
    @sub_group.destroy
    redirect_to sub_groups_url, notice: 'Sub group was successfully destroyed.'
  end

  # DELETE sub_groups/:id/expenses
  def destroy_all_expenses
    @sub_group.expenses.destroy_all
    redirect_to @sub_group, notice: 'Expenses were successfully destroyed.'
  end

  # GET sub_groups/1/download_csv
  def download_csv
    @expenses = Expense.where(sub_group_id: params[:id]).order(:date)
    header = ['Date', 'Category', 'Amount', 'Sub Category']
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      @expenses.each do |expense|
        csv << [expense.date, expense.sub_category.category.name.upcase, expense.amount, expense.sub_category.name.titleize]
      end
    end
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: "expenses-#{@expenses.last.date.strftime("%Y-%m")}-#{@sub_group.name}.csv",
      type: 'text/csv; charset=uft-8'
  end

  # GET /sub_groups/1/download_excel
  def download_excel
    book = RubyXL::Workbook.new
    sheet = book[0]
    @expenses = Expense.where(sub_group_id: params[:id]).order(:date)
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
      filename: "expenses-#{@expenses.last.date.strftime("%Y-%m")}-#{@sub_group.name}.xlsx"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_group
      @sub_group = SubGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sub_group_params
      params.require(:sub_group).permit(:name, :group_id)
    end
end
