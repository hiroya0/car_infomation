# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ブックマーク' do
  let(:user) { create(:user) }
  let(:article) { create(:article) }

  describe 'GET /index' do
    before do
      sign_in user
      get bookmarks_path
    end

    it 'レスポンスが成功すること' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    let(:bookmark_params) do
      {
        article_hashed_url: article.hashed_url,
        url: 'https://example.com',
        title: '記事のタイトル',
        content: '記事のコンテンツ'
      }
    end

    before { sign_in user }

    it '新しいブックマークを作成する' do
      expect { post bookmarks_path, params: bookmark_params }.to change(Bookmark, :count).by(1)
    end

    it 'ブックマークが既に存在する場合は作成しない' do
      create(:bookmark, user: user, article: article)
      expect { post bookmarks_path, params: bookmark_params }.not_to change(Bookmark, :count)
    end
  end

  describe 'DELETE /destroy' do
    let!(:bookmark) { create(:bookmark, user: user, article: article) }

    it '認証されたユーザーがブックマークを削除する' do
      sign_in user
      expect { delete bookmark_path(bookmark) }.to change(Bookmark, :count).by(-1)
    end

    it '未認証のユーザーに対してブックマークの削除を許可しない' do
      delete bookmark_path(bookmark)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
