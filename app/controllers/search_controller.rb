class SearchController < ApplicationController
  def search
    hash_results = SearchService.instance.search(params[:query] + '*')
    render json: hash_results.to_json
  end
end