class RemoveUrlFromPhotos < ActiveRecord::Migration[7.0]
  def change
    remove_column :photos, :url, :string
  end
end
