class ConferencesController < ApplicationController
  def index

  end

  private

  def page_id
    super.merge({page_id: 'conferences'})
  end
end
