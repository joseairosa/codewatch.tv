class CategoriesController < ApplicationController

  def index
    @categories = Category.order_by(viewers: :desc, name: :asc)
  end

  def show
    @category = Category.where(name: params[:category_name].gsub("%2f", "/")).first
    @channels = @category.channels.where(is_online: 1)
  end
end
