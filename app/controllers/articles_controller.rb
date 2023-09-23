class ArticlesController < ApplicationController
  include ApplicationHelper
  def index
    @articles = NewsApiService.fetch_car_news["articles"]
  end

  def show
    hashed_url = params[:id]
    @article = all_articles.find { |a| url_to_hash(a["url"]) == hashed_url }
end
end
