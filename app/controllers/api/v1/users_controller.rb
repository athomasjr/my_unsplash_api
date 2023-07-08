# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorized?, only: [:create]

      def profile
        render json: current_user, status: :accepted
      end

      def create
        user = User.new(create_params)

        if user.valid?
          user.save

          token = issue_token(user_id: user.id)
          render json: { user: UserSerializer.new(user), token: token }, status: :created
        else
          render_error(:failed_create, :unprocessable_entity)
        end
      end

      def update
        input = update_params

        update_avatar(input[:avatar])

        if current_user.update(input.except(:avatar))
          render json: current_user, status: :ok
        else
          render_error(:failed_update, :unprocessable_entity)
        end

      end

      def photos
        render json: current_user.photos, status: :ok
      end

      def update_avatar(avatar_input)
        return unless avatar_input

        avatar_data = handle_avatar_data(avatar_input)
        current_user.upload_and_save_avatar_data(avatar_data)
      end

      def handle_avatar_data(avatar_input)
        file = FileUtil.new(avatar_input)
        return avatar_input unless file.a_uploaded_file?

        file.convert_file_to_data_uri
      end

      def create_params
        params.require(:user).permit(:username, :password).tap do |user_params|
          user_params.require(:username)
          user_params.require(:password)
        end
      end

      def update_params
        params.require(:user).permit(:username, :avatar)
      end
    end
  end
end
