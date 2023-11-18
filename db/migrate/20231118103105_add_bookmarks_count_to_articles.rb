class AddBookmarksCountToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :bookmarks_count, :integer, default: 0
  end
end
