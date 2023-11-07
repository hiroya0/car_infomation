# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '記事一覧' do
  include ApplicationHelper

  before do
    allow(NewsApiService).to receive(:fetch_car_news).and_return({
                                                                   'articles' => [
                                                                     { 'title' => '記事タイトル', 'content' => '記事のコンテンツ',
                                                                       'url' => 'https://example.com/article1' },
                                                                     { 'title' => '自動車', 'content' => '検索結果に車を含むコンテンツ',
                                                                       'url' => 'https://example.com/article2' }
                                                                   ]
                                                                 })
  end

  describe 'GET /index' do
    let!(:article) { create(:article, title: '記事タイトル') }
    let(:keyword) { '車' }
    let(:unrelated_keyword) { 'スクーター' }

    context '検索情報がない時' do
      it '記事の一覧画面が表示されること' do
        get articles_path
        expect(response).to have_http_status(:ok)
      end

      it '特定の記事タイトルが取得されていること' do
        get articles_path
        expect(response.body).to include(article.title)
      end
    end

    context 'キーワード検索する時' do
      it 'キーワードに一致する記事を返すこと' do
        get articles_path, params: { q_title_or_content_cont: keyword }
        expect(response.body).to include(keyword)
      end

      it 'キーワードに一致しない記事が返ってこないこと' do
        get articles_path, params: { q_title_or_content_cont: keyword }
        expect(response.body).not_to include(unrelated_keyword)
      end
    end
  end

  describe 'GET /show' do
    let(:hashed_url) { url_to_hash('https://example.com/article1') }
    let(:article) do
      {
        'title' => '記事タイトル',
        'content' => '記事のコンテンツ'
      }
    end

    context 'データベースに記事が存在しない場合' do
      it '記事の情報が表示されていること' do
        get article_path(hashed_url)
        expect(response.body).to include(article['title'])
        expect(response.body).to include(article['content'])
      end

      it '新しい記事がデータベースに保存されること' do
        expect do
          get article_path(hashed_url)
        end.to change(Article, :count).by(1)
      end
    end

    context 'データベースに記事が既に存在する場合' do
      let!(:existing_article) do
        create(:article, hashed_url: hashed_url,
                         title: article['title'], content: article['content'])
      end

      it '新しい記事がデータベースに保存されないこと' do
        expect do
          get article_path(hashed_url)
        end.not_to change(Article, :count)
      end
    end
  end
end
