class MakeUsernameAndPasswordDigestNonNullInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :username, :string, null: false
    change_column :users, :password_digest, :string, null: false
  end

  def down
    change_column :users, :username, :string
    change_column :users, :password_digest, :string
  end
end
