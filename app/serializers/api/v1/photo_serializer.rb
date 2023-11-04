# frozen_string_literal: true

module Api
  module V1
    class PhotoSerializer < ActiveModel::Serializer
      attributes :id, :url, :label
      belongs_to :user
    end
  end
end
