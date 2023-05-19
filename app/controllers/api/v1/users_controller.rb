# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorized, only: [:create]


      def profile
        render json: { user: UserSerializer.new(current_user) }, status: :accepted
      end

      def create
        @user = User.new(user_params)
        if @user.valid?
          @user.save
          @token = issue_token(user_id: @user.id)
          render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
        else
          render json: { error: I18n.t('errors.user.failed_create') }, status: :not_acceptable
        end
      end




      private

      def user_params
        params.require(:user).permit(:username, :password).tap do |user_params|
          user_params.require(:username)
          user_params.require(:password)
        end
      end
    end
  end
end