# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::DecodeError, with: :handle_jwt_decode_error
    # rescue_from StandardError, with: :handle_error
  end

  def handle_jwt_decode_error(exception)
    log_error(exception&.message)
    render_error(:invalid_token, :unauthorized, :user)
  end

  def handle_error(exception)
    log_error(exception.message)
    render_error(:internal_server_error, :internal_server_error, :exception)
  end

  def render_error(error_key, status, model = nil)
    model ||= controller_name.gsub('_controller', '').singularize
    error_message = I18n.t("errors.#{model}.#{error_key}")
    log_error(error_message)
    render json: { error: error_message }, status: status
  end

  def log_error(error_message)
    Rails.logger.error "An error occurred: #{error_message}"
  end
end
