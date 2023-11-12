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

  before do
    driven_by(:selenium_chrome_headless)
    sign_in user
    allow(NewsApiService).to receive(:fetch_car_news).and_return({
                                                                   'articles' => [article_data]
                                                                 })
  end

  describe 'コメントの投稿' do
    it 'ユーザーが記事にコメントを投稿できる' do
      visit article_path(article_data['hashed_url'])
      fill_in 'comment_content', with: 'いい車'
      click_button 'コメントを投稿'
      expect(page).to have_content 'Car News'
    end
  end

  describe 'コメントの表示' do
    it '記事に対するすべてのコメントが表示される' do
      article = Article.create!(title: article_data['title'], content: article_data['content'], url: article_data['url'], urlToImage:
          article_data['urlToImage'], hashed_url: article_data['hashed_url'])
      create(:comment, article: article, user: user, content: 'いい車')
      visit homes_index_path
      expect(page).to have_content 'いい車'
    end
  end

  describe 'コメントの削除' do
    it 'ユーザーが自分のコメントを削除できる' do
      article = Article.create!(title: article_data['title'], content: article_data['content'], url: article_data['url'], urlToImage:
          article_data['urlToImage'], hashed_url: article_data['hashed_url'])
      create(:comment, article: article, user: user, content: 'いい車')
      visit comments_path
      find('.btn.btn-sm.btn-outline-danger').click
      expect(page).not_to have_content 'いい車'
    end
  end
end
