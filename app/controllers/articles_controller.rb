class ArticlesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = fetch_articles
  end

  def show
    @articles = fetch_articles
    hashed_url = params[:id]
    @article = @articles.find { |a| url_to_hash(a["url"]) == hashed_url }
    @article["hashed_url"] = hashed_url
    @actual_article = Article.find_by(url: @article["url"])
    @comment = @actual_article.comments.build if @actual_article
end

  private

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
