class CreatePhotos < ActiveRecord::Migration[7.0]
  def up
    create_table :photos do |t|
      t.string :label
      t.string :url
      t.references :user, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end

    def down
      drop_table :photos
    end
  end
end
