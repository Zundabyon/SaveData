module GamesHelper
  # サムネイル画像（正方形）
  def game_thumbnail(game, size: 300)
    return unless game.cover_image.attached?
    image_tag game.cover_image.variant(
      resize_to_fill: [ size, size ],
      format: :webp,
      quality: 80
    ),
    class: "rounded-lg",
    loading: "lazy"
  end

  # カバー画像（横長）
  def game_cover(game, width: 800, height: 600)
    return unless game.cover_image.attached?
    image_tag game.cover_image.variant(
      resize_to_fill: [ width, height ],
      format: :webp,
      quality: 85
    ),
    class: "w-full",
    loading: "lazy"
  end

  # レスポンシブ画像
  def game_responsive_image(game, alt: game.title)
    return unless game.cover_image.attached?
    image_tag game.cover_image.variant(resize_to_limit: [ 800, 600 ]),
              srcset: {
                game.cover_image.variant(resize_to_limit: [ 400, 300 ]).url => "400w",
                game.cover_image.variant(resize_to_limit: [ 800, 600 ]).url => "800w",
                game.cover_image.variant(resize_to_limit: [ 1200, 900 ]).url => "1200w"
              },
              sizes: "(max-width: 640px) 400px, (max-width: 1024px) 800px, 1200px",
              alt: alt,
              loading: "lazy",
              class: "w-full h-auto"
  end

  # 画像が存在するかチェック
  def has_image?(game)
    game.cover_image.attached?
  end
end
