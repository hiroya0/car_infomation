# frozen_string_literal: true

class CommentsController < ApplicationController
  include ApplicationHelper

  def index
    @comments = current_user.comments.includes(:article)
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:success] = t('comments.add_success')
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
    end
    redirect_to article_path(url_to_hash(@article.url)) 
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment&.destroy
    flash[:notice] = t('comments.delete_success')
    redirect_to comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
