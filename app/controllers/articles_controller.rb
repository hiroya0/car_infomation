class ArticlesController < ApplicationController
  include ApplicationHelper

  before_action :fetch_articles, only: [:index, :show]

  def index
    @articles = fetch_articles
  end

  def show
    @articles = fetch_articles
    hashed_url = params[:id]
    @article = @articles.find { |a| url_to_hash(a["url"]) == hashed_url }
    @article["hashed_url"] = hashed_url

    @actual_article = Article.find_by(hashed_url: hashed_url)
    
    unless @actual_article
      @actual_article = Article.create(
        hashed_url: hashed_url,
        title: @article["title"],
        content: @article["content"],
        urlToImage: @article["urlToImage"],
        url: @article["url"]
      )
    end

    @comment = @actual_article.comments.build
  end

  private

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
