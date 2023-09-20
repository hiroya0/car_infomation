class ArticlesController < ApplicationController
  def index
    @articles = NewsApiService.fetch_car_news["articles"]
  end
end
