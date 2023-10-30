require 'rails_helper'

RSpec.describe "Articles", type: :request do

    before do
        allow(NewsApiService).to receive(:fetch_car_news).and_return({
          'articles' => [
            { 'title' => '記事タイトル', 'content' => '記事のコンテンツ', 'url' => 'https://example.com/article1' },
            { 'title' => '自動車', 'content' => '検索結果に車を含むコンテンツ', 'url' => 'https://example.com/article2' }
          ]
        })
      end
      
    describe "GET /index" do
      context "検索情報がない時" do
        let!(:article) { create(:article, title: "記事タイトル") }
  
        it "特定の記事タイトルが取得されていること" do
          get "/articles"
          expect(response.body).to include(article.title)
        end
      end
  
      context "キーワード検索する時" do
        let(:keyword) { "車" }
        let!(:article_with_keyword) { create(:article, title: "carinfo: #{keyword}") } 
  
        it "キーワードに一致する記事を返すこと" do
          get "/articles", params: { q_title_or_content_cont: keyword }
          expect(response.body).to include(keyword)
        end
      end
    end
  end
  