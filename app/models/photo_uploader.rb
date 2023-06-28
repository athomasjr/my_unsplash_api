# frozen_string_literal: true

require 'cloudinary/uploader'
require 'cloudinary/utils'
class PhotoUploader
  ACCEPTED_KINDS = %w[photos avatars].freeze
  def initialize(photo, user = nil)
    @photo = photo
    @user = photo.user if photo.respond_to?(:user)
    @user ||= user
    @public_id = generate_public_id
  end

  class << self
    def destroy(public_id)
      Cloudinary::Uploader.destroy(public_id)
    end
  end

  def upload_photo
    upload_to_cloudinary(@photo.url, @public_id, 'photos')
  end

  def upload_user_avatar

    return if @user.blank?

    transformations = user_avatar_transformations
    response = upload_avatar_to_cloudinary(transformations)
    user_avatar_response(response)
  end

  private

  def upload_avatar_to_cloudinary(transformations)
    upload_to_cloudinary(@photo['url'], @public_id, 'avatars', {
                           eager: transformations
                         })
  end

  def user_avatar_response(response)
    {
      transformations: {
        thumbnail: response['eager'][0],
        medium: response['eager'][1],
        large: response['eager'][2]
      },
      public_id: response['public_id']
    }
  end

  def user_avatar_transformations
    [
      { transformation: ['avatar-thumb'] },
      { transformation: ['avatar-med'] },
      { transformation: ['avatar-lg'] }
    ]
  end

  def generate_public_id
    Cloudinary::Utils.random_public_id
  end

  def upload_to_cloudinary(photo_url, public_id, kind = nil, options = {})
    return if @user.blank?

    base_path = "#{ENV.fetch('CLOUDINARY_FOLDER', nil)}/#{@user.id}"
    base_path += "/#{kind}" if kind.present? && validate_kind!(kind)
    Cloudinary::Uploader.upload(photo_url, public_id: public_id,
                                           folder: base_path, **options)
  end

  def validate_kind!(kind)
    ACCEPTED_KINDS.include?(kind) || (raise ArgumentError, "Invalid kind: #{kind}")
  end
end
