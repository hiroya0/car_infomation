# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let!(:comment) { create(:comment, user: user, article: article) }

  before { sign_in user }

  describe 'POST #create' do
    let(:comment_params) { { content: '良い車' } }

    it '新しいコメントを作成する' do
      expect do
        post :create, params: { article_id: article.id, comment: comment_params }
      end.to change(Comment, :count).by(1)
    end

    it '記事一覧ページにリダイレクトする' do
      post :create, params: { article_id: article.id, comment: comment_params }
      expect(response).to redirect_to(articles_path)
    end
  end

  describe 'DELETE #destroy' do
    it 'コメントを削除する' do
      expect do
        delete :destroy, params: { id: comment.id }
      end.to change(Comment, :count).by(-1)
    end

    it 'コメント一覧ページにリダイレクトする' do
      delete :destroy, params: { id: comment.id }
      expect(response).to redirect_to(comments_path)
    end
  end
end
