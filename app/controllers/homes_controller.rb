class HomesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = fetch_articles
    @comments = Comment.all 
  end

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
