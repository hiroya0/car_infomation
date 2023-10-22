class ArticlesController < ApplicationController
  include ApplicationHelper

  before_action :fetch_articles, only: [:index, :show]

  def index
    @articles = fetch_articles
    if params[:q_title_or_content_cont].present?
      keyword = params[:q_title_or_content_cont]
      @articles = @articles.select do |article|
        article["title"].include?(keyword) || article["content"].include?(keyword)
      end
    end    
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
