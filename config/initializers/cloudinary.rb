# frozen_string_literal: true
require 'cloudinary'
# require 'cloudinary/uploader'
# require 'cloudinary/utils'





Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = true
end
