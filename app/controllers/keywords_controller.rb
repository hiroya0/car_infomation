# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keyword = Keyword.new
    @keywords = current_user.keywords
  end

  def create
    @keyword = current_user.keywords.build(keyword_params)
    if @keyword.save
      redirect_to keywords_path, notice: 'キーワードが追加されました。'
    else
      @keywords = current_user.keywords
      render :index
    end
  end

  def destroy
    @keyword = current_user.keywords.find(params[:id])
    @keyword.destroy
    redirect_to keywords_path, error: 'キーワードが削除されました。'
  end

  private

  def keyword_params
    params.require(:keyword).permit(:word)
  end
end
