class HelpController < ApplicationController
  def index

  end

  private

  def page_options
    super.merge({page_id: 'help'})
  end
end
