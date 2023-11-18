# frozen_string_literal: true

class HomesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = fetch_articles
    @articles.sort_by! { |article| article['publishedAt'] }.reverse!
    @articles = @articles.first(10)
  end

  def fetch_articles
    NewsApiService.fetch_car_news['articles']
  end
end
