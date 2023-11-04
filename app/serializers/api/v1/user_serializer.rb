# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :username, :avatar
      has_many :photos unless -> { context_create_action? }

      def attributes(*args)
        hash = super(*args)
        handle_create_action(hash)
        hash
      end

      def avatar
        object.avatar.slice('thumbnail', 'medium', 'large')
      end

      private

      def context_create_action?
        @instance_options.fetch(:context, {}).fetch(:create_action, false)
      end

      def handle_create_action(hash)
        hash.delete(:avatar) if context_create_action?
      end
    end
  end
end
