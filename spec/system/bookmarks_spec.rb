require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  let(:user) { create(:user) }
  let(:article_data) {
    {
      'title' => 'Test Article',
      'content' => 'Test content',
      'url' => 'http://example.com/article',
      'urlToImage' => 'http://example.com/image.jpg',
      'hashed_url' =>  Digest::SHA256.hexdigest('http://example.com/article')[0..15]
    }
  }
  let(:hashed_url) { article_data['hashed_url'] }
  
  before do
    driven_by(:selenium_chrome_headless)
    sign_in user
    allow(NewsApiService).to receive(:fetch_car_news).and_return({
      'articles' => [article_data]
    })
  end

  describe "ブックマーク一覧" do
    it "ユーザーが自分のブックマークを見ることができること" do
     
      article = Article.create!(article_data)
      create(:bookmark, user: user, article: article)
  
      visit bookmarks_path
      
      expect(page).to have_content 'ブックマーク一覧'
      expect(page).to have_content article.title
    end
  end

  describe "ブックマークの作成" do
    it "ユーザーが新しいブックマークを作成できること" do
      # 記事詳細ページに移動
      visit article_path(article_data['hashed_url'])
   
      # Bookmark ボタンが存在するか確認
      expect(page).to have_button('Bookmark')

      # Bookmark ボタンをクリック
      find('input[name="commit"]').click
      
      # 記事一覧ページにリダイレクトされたことを検証
      expect(page).to have_current_path(articles_path)
    end
  end
  
  describe "ブックマークの削除" do
    it "ユーザーがブックマークを削除できること", js: true do
      article = Article.create!(title: article_data['title'], content: article_data['content'], url: article_data['url'], urlToImage: 
        article_data['urlToImage'], hashed_url: article_data['hashed_url'])
      bookmark = create(:bookmark, user: user, article: article)
      visit bookmarks_path
      expect(page).to have_content article.title
      find(".btn.btn-sm.btn-outline-danger").click
      expect(page).not_to have_content article.title
    end
  end
end
