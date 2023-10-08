class BookmarksController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    hashed_url = params[:article_hashed_url]
    @article = Article.find_or_initialize_by(hashed_url: hashed_url)
    if @article.new_record? || (@article.title.nil? && @article.content.nil? && @article.urlToImage.nil?)
      @article.assign_attributes(url: params[:url],title: params[:title], content: params[:content], urlToImage: params[:urlToImage])
      if @article.save
        bookmark = Bookmark.find_or_create_by(user: current_user, article: @article)
        flash[:success] = 'Article was successfully bookmarked.'
      else
        flash[:error] = 'There was an error bookmarking the article.'
      end
    else
      if Bookmark.exists?(user: current_user, article: @article)
        flash[:notice] = 'Article is already bookmarked.'
      else
        Bookmark.create(user: current_user, article: @article)
        flash[:success] = 'Article was successfully bookmarked.'
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
