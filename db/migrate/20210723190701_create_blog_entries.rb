class CreateBlogEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :blog_entries do |t|
      t.string :title, null: false
      t.string :image_url, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
