# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorized, only: [:login]

      def login
        @user = User.find_by(username: user_auth_params[:username])
        if @user&.authenticate(user_auth_params[:password])
          token = issue_token(user_id: @user.id)
          render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
        else
          render json: { error: I18n.t('errors.user.invalid_credentials') }, status: :unauthorized
        end
      end

      private

      def user_auth_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
