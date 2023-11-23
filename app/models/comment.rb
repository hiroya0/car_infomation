# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: true
  validates :content, presence: true
end
