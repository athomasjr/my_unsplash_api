# frozen_string_literal: true
require 'cloudinary/uploader'
require 'cloudinary/utils'
class PhotoUploader
  def initialize(photo)
    @photo = photo
  end

  def upload
    upload_to_cloudinary(@photo.url, @photo.label)
  end

  def destroy
    Cloudinary::Uploader.destroy(@photo.label)
  end

  def find_by_public_id(public_id)
    # Cloudinary::Api.
  end

  private

  def upload_to_cloudinary(photo_url, label)
    Cloudinary::Uploader.upload(photo_url, public_id: label, folder: ENV.fetch('CLOUDINARY_FOLDER', nil))
  end

end
