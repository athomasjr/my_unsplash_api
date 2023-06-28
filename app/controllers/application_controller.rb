# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ErrorHandling

  serialization_scope :current_user
  before_action :authorized?

  def jwt_key
    ENV.fetch('JWT_SECRET', nil)
  end

  def issue_token(payload)
    expiration_time = Time.now.to_i + 3600
    payload[:exp] = expiration_time
    JWT.encode(payload, jwt_key)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    token = auth_header.split[1]
    begin
      decoded = JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      payload = decoded.first
      return nil, { error: 'Token has expired' }.to_json if payload['exp'] && payload['exp'] < Time.now.to_i

      decoded
    rescue JWT::DecodeError
      nil
    end
  end

  def user_id
    return unless decoded_token

    decoded_token&.first&.[]('user_id')
  end

  def current_user
    return unless user_id

    @current_user ||= User.find(user_id)
  end

  def logged_in?
    current_user.present?
  end

  def authorized?(error_key = 'login')
    render_error(error_key, :unauthorized, :user) unless logged_in?
  end
end
