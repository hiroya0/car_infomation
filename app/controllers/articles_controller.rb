# frozen_string_literal: true

class ArticlesController < ApplicationController
  include ApplicationHelper

  before_action :fetch_articles, only: %i[index show]

  def index
    if params[:q_title_or_content_cont].present?
      keyword = params[:q_title_or_content_cont]
      @articles.select! do |article|
        article['title'].include?(keyword) || article['content'].include?(keyword)
      end
    end
  
    filter_by_company if params[:q_company].present?
  end

  def show
    @article = article_function
    return unless @article.is_a?(Article)

    @article.increment_view_count
  end

  private

  def fetch_articles
    @articles = NewsApiService.fetch_car_news['articles']
  end

  def filter_by_company
    company = params[:q_company]
    @articles.select! { |article| article['content'].include?(company) || article['title'].include?(company) }
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
      flash[:error] = t('articles.article_not_found')
      redirect_to root_path
      nil
    end
  end
end
