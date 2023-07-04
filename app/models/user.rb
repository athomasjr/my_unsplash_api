# frozen_string_literal: true

class User < ApplicationRecord


  has_secure_password
  has_many :photos, dependent: :destroy
  validates :username, uniqueness: { case_sensitive: false },
                       presence: { message: I18n.t('errors.user.blank_username') }, on: :create
  validate :validate_unique_username!, on: :create
  validates :password_digest, presence: { message: I18n.t('errors.user.blank_password') }

  def upload_and_save_avatar_data(avatar)
    uploaded_avatar = upload_avatar_to_cloudinary(avatar)
    avatar_object = format_avatar_data(uploaded_avatar)
    update_user_avatar!(avatar_object)
  end

  def update_user_avatar!(updated_avatar)
    update!(avatar: updated_avatar)
  end

  private

  def validate_unique_username!
    return unless User.exists?(username: username)

    errors.add(:username, :username_taken)

    raise ActiveRecord::RecordInvalid.new(self), I18n.t('errors.user.username_taken')
  end

  def upload_avatar_to_cloudinary(avatar)
    PhotoUploader.new(avatar, user: self, kind: 'avatar').upload_user_avatar
  end

  def format_avatar_data(uploaded_avatar)
    {
      public_id: uploaded_avatar[:public_id],
      thumbnail: uploaded_avatar[:transformations][:thumbnail]['url'],
      medium: uploaded_avatar[:transformations][:medium]['url'],
      large: uploaded_avatar[:transformations][:large]['url']
    }
  end
end
