# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: true
  validates :content, presence: { message: "文字を入力してください" }
end
