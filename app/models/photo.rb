# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :user
  validates :label, presence: { message: I18n.t('errors.photo.blank_label') }
  validates :user_id, presence: { message: I18n.t('errors.photo.invalid_user') }
  validates :url, presence: { message: I18n.t('errors.photo.invalid_url') }

  before_save :upload_photo_to_cloudinary, if: :new_record?

  def destroy_photo_and_upload
    destroy
    PhotoUploader.destroy(public_id)
  end

  private

  def upload_photo_to_cloudinary
    uploaded_photo = PhotoUploader.new(self).upload
    self['url'] = uploaded_photo['secure_url']
    self['public_id'] = uploaded_photo['public_id']
  end
end
