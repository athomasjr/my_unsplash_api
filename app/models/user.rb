# frozen_string_literal: true

class User < ApplicationRecord


  has_secure_password
  has_many :photos, dependent: :destroy
  validates :username, uniqueness: { case_sensitive: false },
                       presence: { message: I18n.t('errors.user.blank_username') }, on: :create
  validate :validate_unique_username!, on: :create
  validates :password_digest, presence: { message: I18n.t('errors.user.blank_password') }

  before_save :upload_avatar_to_cloudinary, if: -> { avatar.present? }
  before_save :save_avatar_data, if: -> { avatar.present? }



  private

  def validate_unique_username!
    return unless User.exists?(username: username)

    errors.add(:username, :username_taken)

    raise ActiveRecord::RecordInvalid.new(self), I18n.t('errors.user.username_taken')
  end

  def upload_avatar_to_cloudinary
    @uploaded_avatar = PhotoUploader.new(avatar, self).upload_user_avatar
  end

  def save_avatar_data
    self.avatar = {
      public_id: @uploaded_avatar[:public_id],
      thumbnail: @uploaded_avatar[:transformations][:thumbnail]['url'],
      medium: @uploaded_avatar[:transformations][:medium]['url'],
      large: @uploaded_avatar[:transformations][:large]['url']
    }
  end
end
