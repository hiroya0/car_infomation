# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @comments = current_user.comments.includes(:article)
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    flash[:notice] = t('comments.add_success')
    redirect_to articles_path
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
