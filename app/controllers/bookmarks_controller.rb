class BookmarksController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    hashed_url = params[:article_hashed_url]
    @article = Article.find_or_initialize_by(hashed_url: hashed_url)
    if @article.new_record? 
      @article.attributes = { url: params[:url], title: params[:title], content: params[:content], urlToImage: params[:urlToImage] }
    end
    
    if @article.save
      if Bookmark.exists?(user: current_user, article: @article)
        flash[:notice] = '記事は既にブックマークされています'
      else
        Bookmark.create(user: current_user, article: @article)
        flash[:success] = '記事をブックマークしました'
      end
    end
    redirect_to articles_path 
  end

  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    bookmark&.destroy
    flash[:notice] = 'ブックマークを削除しました'
    redirect_to bookmarks_path
  end

  def index
    @bookmarks = current_user.bookmarks.includes(:article)
  end

  private

  def fetch_articles
    NewsApiService.fetch_car_news["articles"]
  end

  def article_params
    params.require(:article).permit(:hashed_url, :url, :title, :content, :urlToImage)
  end
end
