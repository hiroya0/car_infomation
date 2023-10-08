class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :hashed_url
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
