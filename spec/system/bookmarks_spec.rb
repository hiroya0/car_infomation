# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarks' do
  let(:user) { create(:user) }
  let(:article_data) do
    {
      'title' => 'Test Article',
      'content' => 'Test content',
      'url' => 'http://example.com/article',
      'urlToImage' => 'http://example.com/image.jpg',
      'hashed_url' => Digest::SHA256.hexdigest('http://example.com/article')[0..15]
    }
  end
  let(:hashed_url) { article_data['hashed_url'] }
  let(:article) { Article.create!(article_data) }

  before do
    driven_by(:selenium_chrome_headless)
    sign_in user
    allow(NewsApiService).to receive(:fetch_car_news).and_return('articles' => [article_data])
  end

  describe 'ブックマーク一覧' do
    it 'ユーザーが自分のブックマークを見ることができる' do
      create(:bookmark, user: user, article: article)
      visit bookmarks_path
      expect(page).to have_content article.title
    end
  end

  describe 'ブックマークの作成' do
    before do
      visit article_path(article_data['hashed_url'])
      find('input[name="commit"]').click
    end

    it 'ユーザーが新しいブックマークを作成できる' do
      expect(page).to have_current_path(articles_path)
    end
  end

  describe 'ブックマークの削除' do
    before do
      create(:bookmark, user: user, article: article)
      visit bookmarks_path
    end

    it 'ユーザーがブックマークを削除できる', :js do
      find('.btn.btn-sm.btn-outline-danger').click
      expect(page).not_to have_content article.title
    end
  end
end
