# frozen_string_literal: true

require 'cloudinary/uploader'
require 'cloudinary/utils'
class PhotoUploader
  def initialize(photo)
    @photo = photo
  end

  class << self
    def destroy(public_id)
      Cloudinary::Uploader.destroy(public_id)
    end
  end

  def upload
    public_id = generate_public_id
    upload_to_cloudinary(@photo.url, public_id)
  end

  private

  def generate_public_id
    Cloudinary::Utils.random_public_id
  end

  def upload_to_cloudinary(photo_url, public_id)
    Cloudinary::Uploader.upload(photo_url, public_id: public_id, folder: ENV.fetch('CLOUDINARY_FOLDER', nil))
  end
end
