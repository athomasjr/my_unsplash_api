class AddAvatarToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar, :jsonb, default: {}, null: false
  end
end
