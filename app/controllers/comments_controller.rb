class CommentsController < ApplicationController
  def create
    article = Article.find_or_create_by(hashed_url: params[:hashed_url]) do |a|
      a.title = params[:title]
      a.content = params[:content]
      a.urlToImage = params[:urlToImage]
      a.url = params[:url]
    end
  
    comment = article.comments.build(comment_params)
    comment.user = current_user
  
    if comment.save
      redirect_to article_path(article.hashed_url), notice: 'Comment added successfully!'
    else
      redirect_to article_path(article.hashed_url), alert: 'Failed to add the comment.'
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
