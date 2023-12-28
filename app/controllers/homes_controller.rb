# frozen_string_literal: true

class HomesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = fetch_articles
    @articles.sort_by! { |article| article['publishedAt'] }.reverse!
    @articles = @articles.first(10)

    @top_articles = Article.order(views_count: :desc).limit(5)

    @top_commented_articles = Article.where('comments_count > ?', 0)
                                     .order(comments_count: :desc)
                                     .limit(5)

    @top_bookmarked_articles = Article.where('bookmarks_count > ?', 0)
                                      .order(bookmarks_count: :desc)
                                      .limit(5)

    @keyword_articles = []
    return unless user_signed_in?

    current_user.keywords.each do |keyword|
      fetched_news = NewsApiService.fetch_car_news(keyword: keyword.word)
      @keyword_articles.concat(fetched_news['articles']) if fetched_news['articles']
    end
    @keyword_articles = @keyword_articles.uniq { |article| article['title'] }
    @keyword_articles = @keyword_articles.first(6)
  end

  private

  def fetch_articles
    @articles = NewsApiService.fetch_car_news['articles']
  end

  def article_function
    hashed_url = params[:id]
    article = @articles.find { |a| url_to_hash(a['url']) == hashed_url }

    article.present?
      actual_article = Article.find_by(hashed_url: hashed_url)
      actual_article || Article.create(
        hashed_url: hashed_url,
        title: article['title'],
        content: article['content'],
        urlToImage: article['urlToImage'],
        url: article['url'],
        description: article['description']
      )
  end
end
