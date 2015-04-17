class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def edit_channel
    if request.post?
      category = Category.where(name: params['channel']['category']).first
      if category
        current_user.channel.update_attributes(category: category, title: params['channel']['title'], description: params['channel']['description'])
        flash[:notice] = 'Channel updated'
      else
        flash[:alert] = 'Cannot find that category'
      end
      redirect_to edit_user_channel_path
    end
  end

  def channel
    current_user.channel
  end

  helper_method :channel
end
