require 'httparty'

class NewsApiService
  BASE_URL = "https://newsapi.org/v2/top-headlines"

  def self.fetch_car_news(country: "jp")
    response = HTTParty.get(BASE_URL, query: { country: country, q: "car", apiKey: ENV['NEWS_API_KEY'] })
    response.parsed_response
  end
end
