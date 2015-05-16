class EventsController < ApplicationController

  add_breadcrumb 'Events', :events_path

  def index

  end

  private

  def page_id
    super.merge({page_id: 'events'})
  end
end
