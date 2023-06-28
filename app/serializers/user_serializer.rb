# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar

  def avatar
    object.avatar.slice('thumbnail', 'medium', 'large')
  end

end
