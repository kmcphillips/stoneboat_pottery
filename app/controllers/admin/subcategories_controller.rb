class Admin::SubcategoriesController < ApplicationController
  before_filter :require_login, :set_objects
  
  def new
    @subcategory = @category.subcategories.new
  end
  
  def show
    @subcategory = @category.subcategories.find_by_permalink(params[:id])
  end
  
  def edit
    @subcategory = @category.subcategories.find_by_permalink(params[:id])
  end
  
  def update
    @subcategory = @category.subcategories.find_by_permalink(params[:id])
    
    if @subcategory.update_attributes(params[:subcategory])
      flash[:notice] = "Subcategory successfully updated."
      redirect_to admin_category_path(@category)
    else
      flash[:error] = @subcategory.errors.full_messages.to_sentence
      render 'admin/subcategories/edit'
    end      
  end

  def create
    @subcategory = @category.subcategories.new(params[:subcategory])
    
    if @subcategory.save
      flash[:notice] = "Subcategory successfully created."
      redirect_to admin_category_path(@category)
    else
      flash[:error] = @category.errors.full_messages.to_sentence
      render 'admin/subcategories/new'
    end  
  end

  def destroy
    subcategory = @category.subcategories.find_by_permalink(params[:id])

    if subcategory.forms.size > 0
      flash[:error] = "You can only delete empty subcategories. This subcategory has #{subcategory.forms.size} forms."
    else
      if subcategory.delete
        flash[:notice] = "Subcategory successfully deleted."
      else
        flash[:error] = subcategory.errors.full_messages.to_sentence
      end
    end

    redirect_to admin_category_path(@category)
  end

protected

  def set_objects
    @category = Category.find_by_permalink(params[:category_id])
  end  
end