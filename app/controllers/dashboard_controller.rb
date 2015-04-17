class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def edit_channel

  end

  def channel
    current_user.channel
  end

  helper_method :channel
end
