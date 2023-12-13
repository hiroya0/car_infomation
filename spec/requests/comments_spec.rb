# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'コメント' do
  include ApplicationHelper

  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let!(:comment) { create(:comment, user: user, article: article) }

  before { sign_in user }

  describe 'POST #create' do
    let(:comment_params) { { content: '良い車' } }

    it '新しいコメントを作成する' do
      expect do
        post article_comments_path(article), params: { comment: comment_params }
      end.to change(Comment, :count).by(1)
    end

    it '記事詳細ページにリダイレクトする' do
      post article_comments_path(article), params: { comment: comment_params }
      expect(response).to redirect_to article_path(url_to_hash(article.url))
    end
  end

  describe 'DELETE #destroy' do
    it 'コメントを削除する' do
      expect do
        delete comment_path(comment)
      end.to change(Comment, :count).by(-1)
    end

    it 'コメント一覧ページにリダイレクトする' do
      delete comment_path(comment)
      expect(response).to redirect_to(comments_path)
    end
  end
end
