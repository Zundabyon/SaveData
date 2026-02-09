class Game < ApplicationRecord
  belongs_to :user
  has_one_attached :cover_image

  # タイトルのバリデーション
  validates :title, presence: true, length: { maximum: 100 }
  
  # プレイした年齢（必須、0〜120歳）
  validates :played_age, 
            presence: true,
            numericality: { 
              only_integer: true,                    # 整数のみ
              greater_than_or_equal_to: 0,           # 0以上
              less_than_or_equal_to: 120             # 120以下
            }
  
  # 楽しさ（任意、1〜10の整数）
  validates :fun, 
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 10
            }, 
            allow_nil: true
  
  # 難しさ（任意、1〜10の整数）
  validates :difficulty, 
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 10
            }, 
            allow_nil: true

  # その他のフィールド（任意）
  validates :hardware, length: { maximum: 50 }, allow_blank: true
  validates :genre, length: { maximum: 50 }, allow_blank: true
  validates :memo, length: { maximum: 500 }, allow_blank: true

  # カバー画像のバリデーション
  validates :cover_image,
            content_type: ["image/png", "image/jpeg", "image/gif", "image/webp"],
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
