# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def index
    @bookmarks = current_user.bookmarks.includes(:article)
  end

  def create
    @article = find_or_initialize_article_from_params
    save_article_and_create_bookmark
    redirect_to article_path(url_to_hash(@article.url))
  end

  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    bookmark&.destroy
    flash[:error] = t('bookmarks.delete_success')
    redirect_to bookmarks_path
  end

  private

  def find_or_initialize_article_from_params
    Article.find_or_initialize_by(hashed_url: params[:article_hashed_url]).tap do |article|
      article.attributes = params.slice(:url, :title, :content, :urlToImage) if article.new_record?
    end
  end

  def save_article_and_create_bookmark
    return unless @article.save

    create_bookmark_or_set_flash
  end

  def create_bookmark_or_set_flash
    if Bookmark.exists?(user: current_user, article: @article)
      flash[:error] = t('bookmarks.already_bookmarked')
    else
      Bookmark.create(user: current_user, article: @article)
      flash[:success] = t('bookmarks.bookmark_success')
    end
  end
end
