class Article < ApplicationRecord
  has_many :bookmarks
  has_many :users, through: :bookmarks
  has_many :comments
end
