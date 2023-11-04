require 'rails_helper'

RSpec.describe "ブックマーク", type: :request do
  let(:user) { create(:user) }
  let(:article) { create(:article) }

  describe "GET /index" do
    context "ユーザーが認証されている場合" do
      before { sign_in user }

      it "ブックマーク一覧を表示する" do
        get bookmarks_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /create" do
    context "ユーザーが認証されている場合" do
      before { sign_in user }

      it "新しいブックマークを作成する" do
        expect {
          post bookmarks_path, params: { 
            article_hashed_url: article.hashed_url,
            url: "https://example.com",
            title: "記事のタイトル",
            content: "記事のコンテンツ" }
        }.to change(Bookmark, :count).by(1)
      end

      it "ブックマークが既に存在する場合は作成しない" do
        create(:bookmark, user: user, article: article)
        expect {
          post bookmarks_path, params: { 
            article_hashed_url: article.hashed_url,
            url: "https://example.com",
            title: "記事のタイトル",
            content: "記事のコンテンツ" }
        }.not_to change(Bookmark, :count)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:bookmark) { create(:bookmark, user: user, article: article) }

    context "ユーザーが認証されている場合" do
      before { sign_in user }

      it "ブックマークを削除する" do
        expect {
          delete bookmark_path(bookmark)
        }.to change(Bookmark, :count).by(-1)
      end
    end

    context "ユーザーが認証されていない場合" do
      it "ブックマークの削除を許可しない" do
        expect {
          delete bookmark_path(bookmark)
        }.not_to change(Bookmark, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
