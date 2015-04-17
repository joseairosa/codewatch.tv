class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
      @category = Category.where(name: params[:category_name].gsub("%2f", "/")).first
      @channels = @category.channels
  end
end
