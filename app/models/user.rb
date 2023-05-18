# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :photos, dependent: :destroy
  validates :username, uniqueness: { case_sensitive: false }, presence: { message: I18n.t('errors.user.blank_username') }
  validates :password_digest, presence: { message: I18n.t('errors.user.blank_password') }
end
