class HomesController < ApplicationController
  include ApplicationHelper

  def index
    @commented_articles = Article.joins(:comments).distinct
    @comments = Comment.includes(:user, :article).all
  end

  def fetch_articles
    NewsApiService.fetch_car_news['articles']
  end
end
