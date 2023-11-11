require 'rails_helper'

RSpec.describe "Articles", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:selenium_chrome_headless)
    sign_in user

    create(:article, title: '車', content: '車')
  end

  describe "記事一覧" do
    it "ユーザーが記事一覧を見ることができる" do
      visit articles_path
      expect(page).to have_content '車'
    end
  end

  describe "記事詳細" do
    it "ユーザーが記事の詳細を見ることができる" do
      visit articles_path
      click_link '詳細を見る', match: :first
      expect(page).to have_content '車'
    end
  end

  describe "記事検索" do
    it "ユーザーが記事を検索できる" do
      visit articles_path
      fill_in 'q_title_or_content_cont', with: '車'
      click_button '検索'
      expect(page).to have_content '車'
    end
  end
end
