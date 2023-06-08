# frozen_string_literal: true

module Api
  module V1
    class PhotosController < ApplicationController
      skip_before_action :authorized?, only: [:index]

      def index
        photos = Photo.all
        render json: photos, status: :ok
      end

      # @todo: auto generate public_id and maybe store it so users can update the same image if they want
      def create
        photo = current_user.photos.build(photo_params)
        if photo.save
          render json: photo, status: :created
        else
          render_error(:failed_create, :not_acceptable)
        end
      end

      def destroy
        return unless params[:id]

        photo = current_user.photos.find_by(id: params[:id])

        return render json: { message: I18n.t('errors.photo.not_found') }, status: :not_found if photo.blank?

        if photo.present?
          photo.destroy_photo_and_upload
          render json: { message: I18n.t('errors.photo.photo_deleted') }, status: :ok
        else
          render_error(:failed_delete, :not_acceptable)
        end
      end

      private

      def photo_params
        params.require(:photo).permit(:label, :url)
      end
    end
  end
end
