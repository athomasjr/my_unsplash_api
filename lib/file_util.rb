# frozen_string_literal: true

class FileUtil
  require 'base64'

  def initialize(file)
    @file = file
  end

  def convert_file_to_data_uri
    file_data = read_file
    base64_data = base64_encode(file_data)
    base64_data_uri(base64_data)
  end

  def a_uploaded_file?
    @file.respond_to?(:tempfile)
  end

  private


  def read_file
    File.read(@file.tempfile)
  end

  def base64_encode(file_data)
    Base64.strict_encode64(file_data)
  end

  def base64_data_uri(base64_data)
    "data:#{@file.content_type};base64,#{base64_data}"
  end

end
