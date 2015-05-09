class CategoriesController < ApplicationController

  add_breadcrumb 'Categories', :categories_path

  helper_method :category
  helper_method :channels

  def index
    @categories = Category.order_by(viewers: :desc, name: :asc)
  end

  def show
    @category = Category.where(name: params[:category_name].gsub("%2f", "/")).first
    @channels = @category.channels.where(is_online: 1).order_by(current_viewers: :desc, name: :asc)

    add_breadcrumb @category.name, category_channels_path(@category.name)
  end

  private

  def category
    @category
  end

  def channels
    @channels
  end
end
