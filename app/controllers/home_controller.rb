class HomeController < ApplicationController
  include ChannelHelper

  TOP_LANGUAGES = %w(Java C C++ C# Python JavaScript PHP Ruby Objective-C Go)

  helper_method :featured_channels
  helper_method :featured_streamers
  helper_method :top_categories
  helper_method :top_languages
  helper_method :latest_posts

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
    Channel.where(is_online: 1, :current_viewers.gt => 0).order_by(current_viewers: :desc).limit(3).to_a
  end

  def featured_streamers
    User.where(featured: 1).to_a
  end

  def latest_posts
    CW_BLOG.getPosts(filter: {number: 3, orderby: 'post_date', order: 'desc'})
  end
end
