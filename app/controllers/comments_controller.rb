class CommentsController < ApplicationController
  
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
      flash[:notice] = "コメントが正常に追加されました"
      redirect_to articles_path
  end

  def destroy
    @comment.destroy
    flash[:notice] = "コメントが正常に削除されました"
    redirect_to homes_path
  end

  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end
