class Article < ApplicationRecord
  has_many :bookmarks
  has_many :users, through: :bookmarks
  validates :hashed_url, uniqueness: true
end
