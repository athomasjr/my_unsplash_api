# frozen_string_literal: true

class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :url, :label
  # has_one :user, serializer: UserSerializer
end
