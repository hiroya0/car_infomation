require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
    let(:user) { create(:user) }
    let!(:article) { create(:article) } 
  
    before do
      driven_by(:selenium_chrome_headless)
      sign_in user
    end
    
  describe "ブックマーク一覧" do
    it "ユーザーが自分のブックマークを見ることができること" do
      create(:bookmark, user: user, article: article)
      visit bookmarks_path
      expect(page).to have_content 'ブックマーク一覧'
      expect(page).to have_content article.title
    end
  end

  describe "ブックマークの作成" do
    it "ユーザーが新しいブックマークを作成できること" do
      
      visit article_path(article)
      
      expect(page).to have_button('Bookmark')
      click_button "Bookmark"     
      expect(page).to have_current_path(articles_path)
    end
  end
  
  describe "ブックマークの削除" do
    it "ユーザーがブックマークを削除できること", js: true do
      bookmark = create(:bookmark, user: user, article: article)
      visit bookmarks_path
      expect(page).to have_content article.title
      find(".btn-outline-danger[data-method='delete'][href='#{bookmark_path(bookmark)}']").click
      expect(page).not_to have_content article.title
    end
  end
end
