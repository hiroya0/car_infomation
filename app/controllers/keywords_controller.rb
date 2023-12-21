# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keyword = Keyword.new
    @keywords = current_user.keywords
  end

  def create
    @keyword = current_user.keywords.build(keyword_params)
    if @keyword.save
      redirect_to keywords_path, notice: t('keywords.add_success')
    else
      @keywords = current_user.keywords
      redirect_to keywords_path, alert: t('keywords.delete_success')
    end
  end

  def destroy
    @keyword = current_user.keywords.find(params[:id])
    @keyword.destroy
    redirect_to keywords_path, alert: t('keywords.alert')
  end

  private

  def keyword_params
    params.require(:keyword).permit(:word)
  end
end
