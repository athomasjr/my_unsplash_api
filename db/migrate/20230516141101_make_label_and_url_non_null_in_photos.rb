class MakeLabelAndUrlNonNullInPhotos < ActiveRecord::Migration[7.0]
  def up
    change_column :photos, :label, :string, null: false
    change_column :photos, :url, :string, null: false
  end

  def down
    change_column :photos, :label, :string
    change_column :photos, :url, :string
  end
end
