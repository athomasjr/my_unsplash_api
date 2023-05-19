# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :label, presence: { message: I18n.t('errors.photo.blank_label') }
  validates :user_id, presence: { message: I18n.t('errors.photo.invalid_user') }
  validates :validate_image_presence

  before_save :store_cloudinary_url, if: :image_attached?

  private

  def store_cloudinary_url
    self.url = image.service_url
  end

  def validate_image_presence
    errors.add(:image, I18n.t('errors.photo.blank_image')) unless image.attached?
  end

end
