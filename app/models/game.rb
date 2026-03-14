# == Schema Information
#
# Table name: games
#
#  id             :bigint           not null, primary key
#  difficulty     :integer
#  ended_year     :integer
#  fun            :integer
#  genre          :string
#  hardware       :string
#  igdb_cover_url :string
#  memo           :text
#  played_age     :integer
#  played_year    :integer
#  recommended    :string
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
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

  #　ここにハードウェアの選択肢をグループにして定義しています
  HARDWARE_GROUPED = {
    "据え置き機" => [
      "ファミコン", "スーパーファミコン", "ニンテンドー64", "ゲームキューブ", "Wii", "Nintendo Switch",
      "プレステ", "プレステ２", "プレステ３", "プレステ４", "プレステ５",
      "セガサターン", "メガドライブ", "ネオジオ", "アーケード機"
    ],
    "携帯機" => [
      "ゲームボーイ", "ゲームボーイアドバンス", "Nintendo DS", "Nintendo 3DS",
      "PSP", "PS Vita"
    ],
    "その他" => [ "PC", "スマートフォン", "その他" ]
  }.freeze

  HARDWARE_OPTIONS = HARDWARE_GROUPED.values.flatten.freeze

  #　ここにゲームジャンルの選択肢を定義しています
  GENRE_OPTIONS = [
    "アクション", "シューティング", "格闘", "スポーツ",
    "RPG", "アクションRPG", "アドベンチャー", "ノベル",
    "シミュレーション", "ストラテジー", "パズル", "ボードゲーム", "その他"
  ].freeze

  # タイトルのバリデーション
  validates :title, presence: true, length: { maximum: 50 }

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
  validates :hardware, length: { maximum: 40 }, allow_blank: true
  validate :hardware_custom_length
  validates :genre, length: { maximum: 20 }, allow_blank: true
  validate :genre_custom_length
  validates :memo, length: { maximum: 150 }, allow_blank: true

  # カバー画像のバリデーション
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

  private

  def hardware_custom_length
    return if hardware.blank?
    return if hardware.in?(HARDWARE_OPTIONS)
    errors.add(:hardware, "は10文字以内で入力してください（その他の場合）") if hardware.length > 10
  end

  def genre_custom_length
    return if genre.blank?
    return if genre.in?(GENRE_OPTIONS)
    errors.add(:genre, "は10文字以内で入力してください（その他の場合）") if genre.length > 10
  end
end
