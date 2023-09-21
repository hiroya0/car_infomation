require 'httparty'

class NewsApiService
  BASE_URL = "https://newsapi.org/v2/everything"

  def self.fetch_car_news(language: "jp")
    response = HTTParty.get(BASE_URL, query: { q: "車", language: language, apiKey: ENV['NEWS_API_KEY'] })
    response.parsed_response
  end
end
