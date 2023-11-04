# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { '記事のタイトル' }
    content { '記事のコンテンツ' }
  end
end
