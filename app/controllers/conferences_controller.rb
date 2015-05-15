class ConferencesController < ApplicationController

  add_breadcrumb 'Conferences', :conferences_path

  def index

  end

  private

  def page_id
    super.merge({page_id: 'conferences'})
  end
end
