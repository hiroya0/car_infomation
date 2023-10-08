class AddUrlToImageToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :urlToImage, :string
  end
end
