class AddPublicIdToPhotos < ActiveRecord::Migration[7.0]
  def change
    add_column :photos, :public_id, :string, unique: true
  end
end
