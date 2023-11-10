# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { '記事のタイトル' }
    content { '記事のコンテンツ' }
    url {'https://example.com/article'}
    hashed_url { Digest::SHA256.hexdigest(url)[0..15] }
  end
end
