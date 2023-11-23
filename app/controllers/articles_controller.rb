# frozen_string_literal: true

class ArticlesController < ApplicationController
  include ApplicationHelper

  before_action :fetch_articles, only: %i[index show]

  def index
    return if params[:q_title_or_content_cont].blank?

    keyword = params[:q_title_or_content_cont]
    @articles = @articles.select do |article|
      article['title'].include?(keyword) || article['content'].include?(keyword)
    end
    
  end

  def show
    @article = article_function
    return unless @article
    @article.increment_view_count
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
        description: article['description'],
        urlToImage: article['urlToImage'],
        url: article['url']
      )
    else
      flash[:alert] = t('article_not_found')
      redirect_to articles_path and return
    end
  end
end
