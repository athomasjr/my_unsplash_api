# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :user
  validates :url, presence: { message: I18n.t('errors.photo.blank_url') }
  validates :user_id, presence: { message: I18n.t('errors.photo.invalid_user') }
  validates :url, presence: { message: I18n.t('errors.photo.blank_url') }
end
