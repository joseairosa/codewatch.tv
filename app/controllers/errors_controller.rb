class ErrorsController < ApplicationController
  def error404
    render status: :not_found
  end

  private

  def page_id
    super.merge({page_id: 'errors'})
  end
end
