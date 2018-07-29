class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :download_excel, :download_sums_excel]
  before_action :set_expenses, only: [:show, :download_excel, :download_sums_excel]
  before_action :set_sub_categories, only: [:show, :download_sums_excel]
  before_action :set_sub_groups, only: [:show, :download_sums_excel]

  # GET /groups
  def index
    @groups = Group.all
  end

  # GET /groups/1
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  # GET /sub_groups/1/download_excel
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
      filename: "expenses-#{@group.name}.xlsx"
  end

  # GET /expenses/download_sum_excel
  def download_sums_excel
    book = RubyXL::Workbook.new
    sheet = book[0]
    lastest_i = nil
    @sub_categories.each_with_index do |sub_category, i|
      sheet.add_cell(i, 0, sub_category.date_span(@group.id))
      sheet.add_cell(i, 1, sub_category.category.name.upcase)
      sum = sub_category.expenses.where(sub_group: @sub_groups).sum(:amount)
      c = sheet.add_cell(i, 2, sum)
      c.set_number_format("[$¥-ja-JP]* #,###")
      sheet.add_cell(i, 3, sub_category.name.titleize)
      lastest_i = i
    end
    sheet.add_cell(lastest_i+1, 0, 'Total')
    c = sheet.add_cell(lastest_i+1, 2, '', "SUM(C1:C#{lastest_i+1})")
    c.set_number_format("[$¥-ja-JP]* #,###")
    send_data book.stream.read,
      type: 'application/excel',
      filename: "expenses-sums-#{@group.name}.xlsx"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def set_expenses
      sub_groups = SubGroup.where(group: @group)
      @expenses = Expense.where(sub_group: sub_groups)
      @expenses.order(:date, :category)
    end

    def set_sub_categories
      @sub_categories = []
      @expenses.each do |expense|
        @sub_categories.push(expense.sub_category) if !@sub_categories.include?(expense.sub_category)
      end
      @sub_categories.sort_by! {|sc| [sc.category.name, sc.name] }
    end

    def set_sub_groups
      @sub_groups = SubGroup.where(group: @group)
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name)
    end
end
