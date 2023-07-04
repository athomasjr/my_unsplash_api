# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorized?, only: [:create]

      def profile
        render json: current_user, status: :accepted
      end

      def create
        fetch_new_user_data
        user = User.new(@create_user_params)

        if user.valid?
          user.save

          user.upload_and_save_avatar_data(@user_avatar_params) if @avatar_file.a_uploaded_file?

          token = issue_token(user_id: user.id)
          render json: { user: UserSerializer.new(user), token: token }, status: :created
        else
          render json: { error: I18n.t('errors.user.failed_create') }, status: :not_acceptable
        end
      end

      def photos
        render json: current_user.photos, status: :ok
      end

      private

      def fetch_new_user_data
        @create_user_params = user_params
        @user_avatar_params = create_params[:avatar]
        @avatar_file = FileUtil.new(@user_avatar_params)
      end

      def user_avatar_data(user_data)
        file = FileUtil.new(user_data[:avatar])
        return unless file.a_uploaded_file?

        user_data[:avatar] = file.convert_file_to_data_uri
      end

      def user_params
        create_params.except(:avatar)
      end

      def create_params
        params.require(:user).permit(:username, :password, :avatar).tap do |user_params|
          user_params.require(:username)
          user_params.require(:password)
        end
      end
    end
  end
end
