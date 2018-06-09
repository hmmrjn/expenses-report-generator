class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  def index
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
  end

  # POST /expenses
  def create
    session[:current_day] = params[:expense]['date(3i)']
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
