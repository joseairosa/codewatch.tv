class HomeController < ApplicationController
  include ChannelHelper

  TOP_LANGUAGES = %w(Java C C++ C# Python JavaScript PHP Ruby Objective-C Go)

  helper_method :featured_channels
  helper_method :featured_streamers
  helper_method :top_categories
  helper_method :top_languages

  def index
  end

  private

  def top_languages
    TOP_LANGUAGES
  end

  def top_categories
    @top_categories ||= Category.in(name: TOP_LANGUAGES).inject({}) { |res, category| res[category.name] = category; res }
  end

  def featured_channels
    first_channel = Channel.first
    [first_channel, first_channel, first_channel]
  end

  def featured_streamers
    first_user = User.first
    [first_user, first_user, first_user]
  end
end
