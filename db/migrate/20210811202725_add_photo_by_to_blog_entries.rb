class AddPhotoByToBlogEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :blog_entries, :photo_by, :string, default: 'not sourced'
  end
end
