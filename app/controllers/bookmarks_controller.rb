class BookmarksController < ApplicationController
  include ApplicationHelper

  def create
    article = Article.find_by(hashed_url: params[:article_hashed_url])
    bookmark = current_user.bookmarks.build(article: article) 
    
    if bookmark.save
      flash[:notice] = 'ブックマーク登録しました'
      redirect_to articles_path
    else
      flash[:alert] = 'ブックマークに失敗しました'
      redirect_to articles_path
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(article_hashed_url: params[:article_hashed_url])
    bookmark.destroy
    flash[:notice] = 'ブックマークを削除しました'
    redirect_to articles_path
  end

  private

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end
end
