# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  difficulty  :integer
#  ended_year  :integer
#  fun         :integer
#  genre       :string
#  hardware    :string
#  memo        :text
#  played_age  :integer
#  played_year :integer
#  recommended :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_games_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Game < ApplicationRecord
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :played_age, presence: true
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
