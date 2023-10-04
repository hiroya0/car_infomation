class BookmarksController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    hashed_url = params[:article_hashed_url]
    @article = Article.find_or_initialize_by(hashed_url: hashed_url)
    bookmark = Bookmark.find_or_create_by(user: current_user, article: @article)
    Rails.logger.debug "Hashed URL: #{hashed_url}"
    Rails.logger.debug "New Record?: #{@article.new_record?}"
    
    if @article.new_record?
      @article.assign_attributes(title: params[:title], content: params[:content], urlToImage: params[:urlToImage])
      if @article.save
        flash[:success] = 'Article was successfully bookmarked.'
      else
        flash[:error] = 'There was an error bookmarking the article.'
      end
    else
      flash[:notice] = 'Article is already bookmarked.'
    end
    redirect_to articles_path 
end


  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    Rails.logger.debug "Deleting bookmark: #{bookmark.inspect}"
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
end
