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
  end

  private

  def fetch_articles
    @articles = NewsApiService.fetch_car_news['articles']
  end

  def article_function
    hashed_url = params[:id]
    article = @articles.find { |a| url_to_hash(a['url']) == hashed_url }

    if article.present?
      actual_article = Article.find_by(hashed_url: hashed_url)
      actual_article || Article.create(
        hashed_url: hashed_url,
        title: article['title'],
        content: article['content'],
        urlToImage: article['urlToImage'],
        url: article['url']
      )
    else
      flash[:alert] = t('article_not_found')
      redirect_to articles_path and return
    end
  end
end
