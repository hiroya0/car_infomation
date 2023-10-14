class HomesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = fetch_articles
    @comments = Comment.includes(:user, :article).all
  end

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
