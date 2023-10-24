# frozen_string_literal: true

class Article < ApplicationRecord
  has_many :users, through: :bookmarks
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
end
