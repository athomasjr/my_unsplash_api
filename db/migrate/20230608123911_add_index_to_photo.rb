class AddIndexToPhoto < ActiveRecord::Migration[7.0]
  def change
    add_index :photos, [:public_id, :url], unique: true
  end
end
