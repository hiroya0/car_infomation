# frozen_string_literal: true

class HomesController < ApplicationController
  include ApplicationHelper

  def index
    @articles = Article.order(created_at: :desc).limit(10)
  end

  def fetch_articles
    NewsApiService.fetch_car_news['articles']
  end
end
