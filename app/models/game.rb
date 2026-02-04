# app/models/game.rb
class Game < ApplicationRecord
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :cover_image,
            content_type: [ "image/png", "image/jpeg", "image/gif", "image/webp" ],
            size: { less_than: 5.megabytes, message: "5MB以下にしてください" }

  # 仮想属性を追加
  attr_accessor :remove_cover_image

  scope :with_images, -> {
    includes(cover_image_attachment: :blob)
  }

  # サムネイルURLをキャッシュ
  def thumbnail_url(size: 300)
    return unless cover_image.attached?

    Rails.cache.fetch(
      [ "game_thumbnail", id, cover_image.blob.checksum, size ],
      expires_in: 1.day
    ) do
      cover_image.variant(
        resize_to_fill: [ size, size ],
        format: :webp
      ).processed.url
    end
  end

  # カバー画像URLをキャッシュ
  def cover_url
    return unless cover_image.attached?

    Rails.cache.fetch(
      [ "game_cover", id, cover_image.blob.checksum ],
      expires_in: 1.day
    ) do
      cover_image.variant(
        resize_to_fill: [ 800, 600 ],
        format: :webp
      ).processed.url
    end
  end
end
