# frozen_string_literal: true

require 'cloudinary/uploader'
require 'cloudinary/utils'
class PhotoUploader
  ACCEPTED_KINDS = %w[photo avatar].freeze
  def initialize(file, user: nil, kind: nil)
    @file = format_file(file)
    @user = user
    @public_id = generate_public_id
    @kind = kind
    @upload_folder_path = upload_folder_path
  end

  class << self
    def destroy(public_id)
      Cloudinary::Uploader.destroy(public_id)
    end
  end

  def upload_photo
    upload_to_cloudinary(@file, @public_id)
  end

  def upload_user_avatar
    return if @user.blank?

    transformations = user_avatar_transformations
    response = upload_avatar_to_cloudinary(transformations)
    user_avatar_response(response)
  end

  private

  def upload_avatar_to_cloudinary(transformations)
    upload_to_cloudinary(@file, @public_id, { eager: transformations })
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

  def upload_to_cloudinary(file, public_id, options = {})
    return if @user.blank?

    Cloudinary::Uploader.upload(file, public_id: public_id,
                                      folder: @upload_folder_path, **options)
  end

  def upload_folder_path
    base_path = "#{ENV.fetch('CLOUDINARY_FOLDER', nil)}/#{@user&.id}"
    base_path += "/#{@kind}" if @kind.present? && validate_kind!(@kind)
    base_path
  end

  def format_file(file)
    return file if file.is_a?(String)

    uploaded_file = FileUtil.new(file)
    uploaded_file.convert_file_to_data_uri if uploaded_file.a_uploaded_file?
  end

  def validate_kind!(kind)
    ACCEPTED_KINDS.include?(kind) || (raise ArgumentError, "Invalid kind: #{kind}")
  end
end
