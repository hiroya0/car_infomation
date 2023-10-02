class BookmarksController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    puts params
    article = Article.find_or_create_by(hashed_url: params[:article_hashed_url]) do |article|
      
      article.title = params[:title]
      article.content = params[:content]
      article.urlToImage = params[:urlToImage]
    end

    bookmark = current_user.bookmarks.build(article: article) 
    
    if bookmark.save
      flash[:notice] = 'ブックマーク登録しました'
      redirect_to articles_path
    else
      puts bookmark.errors.full_messages
      flash[:alert] = 'ブックマークに失敗しました'
      redirect_to articles_path
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(article: Article.find_by(hashed_url: params[:article_hashed_url]))
    bookmark&.destroy
    flash[:notice] = 'ブックマークを削除しました'
    redirect_to articles_path
  end

  def index
    @bookmarks = current_user.bookmarks.includes(:article)
  end

  private

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
