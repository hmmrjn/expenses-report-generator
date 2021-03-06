class SubCategoriesController < ApplicationController
  before_action :set_sub_category, only: [:show, :edit, :update, :destroy]

  # GET /sub_categories
  def index
    @sub_categories = SubCategory.order(:category_id, :name)
  end

  # GET /sub_categories/1
  def show
  end

  # GET /sub_categories/new
  def new
    @sub_category = SubCategory.new
    @sub_category.category_id = params[:category_id] if params[:category_id]
    @categories = Category.all
  end

  # GET /sub_categories/1/edit
  def edit
    @categories = Category.all
  end

  # POST /sub_categories
  def create
    @sub_category = SubCategory.new(sub_category_params)

    if @sub_category.save
      redirect_to @sub_category, notice: 'Sub category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sub_categories/1
  def update
    if @sub_category.update(sub_category_params)
      redirect_to @sub_category, notice: 'Sub category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sub_categories/1
  def destroy
    @sub_category.destroy
    redirect_to sub_categories_url, notice: 'Sub category was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_category
      @sub_category = SubCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sub_category_params
      params[:sub_category][:name] = params[:sub_category][:name].downcase
      params.require(:sub_category).permit(:name, :category_id)
    end
end
