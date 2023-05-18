# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorized

  def jwt_key
    ENV.fetch('JWT_SECRET', nil)
  end

  def issue_token(payload)
    JWT.encode(payload, jwt_key)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    token = auth_header.split[1]
    begin
      JWT.decode(token, jwt_key, true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end

  end

  def user_id

    return unless decoded_token

    decoded_token.first['user_id']
  end

  def current_user
    return unless user_id

    @current_user ||= User.find_by(id: user_id)
  end

  def logged_in?
    current_user.present?
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
