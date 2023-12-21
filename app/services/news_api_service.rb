# frozen_string_literal: true

require 'httparty'

class NewsApiService
  BASE_URL = 'https://newsapi.org/v2/everything'

  def self.fetch_car_news(keyword: '車', language: 'jp')
    query = { q: keyword, language: language, apiKey: ENV.fetch('NEWS_API_KEY', nil) }
    response = HTTParty.get(BASE_URL, query: query)
    response.parsed_response
  end
end
