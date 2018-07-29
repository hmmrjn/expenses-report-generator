class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all
  end

  # GET /groups/1
  def show
    @sub_groups = SubGroup.where(group: @group) # used in View
    @expenses = Expense.where(sub_group: @sub_groups)
    @expenses.order(:date, :category)
    @sub_categories = []
    @expenses.each do |expense|
      @sub_categories.push(expense.sub_category) if !@sub_categories.include?(expense.sub_category)
    end
    @sub_categories.sort_by! {|sc| [sc.category.name, sc.name] }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name)
    end
end
