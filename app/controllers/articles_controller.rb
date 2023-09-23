class ArticlesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = fetch_articles
  end

  def show
    @articles = fetch_articles
    hashed_url = params[:id]
    @article = @articles.find { |a| url_to_hash(a["url"]) == hashed_url }
  end

  private

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
