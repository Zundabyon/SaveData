class IgdbService
  IGDB_BASE_URL = "https://api.igdb.com/v4"

  # ===================================================================
  # 公開API
  # ===================================================================

  # ゲームを検索する（日本語・英語を自動判定して振り分け）
  def self.search(query)
    token = get_token
    contains_japanese?(query) ? search_by_alternative_names(query, token) : search_games_directly(query, token)
  end

  # ===================================================================
  # 検索ロジック（private）
  # ===================================================================

  private_class_method def self.search_by_alternative_names(query, token)
    # 日本語タイトルはIGDBの alternative_names テーブルに登録されているため、
    # games テーブルの直接検索ではヒットしない。
    # alternative_names 経由でゲーム情報を取得する。
    body = <<~BODY
      fields game.name, game.cover.image_id, game.platforms.name, game.genres.name, name;
      where name ~ *"#{sanitize(query)}"*;
      limit 100;
    BODY

    results = igdb_request("/alternative_names", body, token)
    return [] unless results

    results.filter_map do |alt|
      next unless alt["game"]
      alt["game"].merge(
        "alternative_name" => alt["name"],
        "cover_url"        => build_cover_url(alt.dig("game", "cover", "image_id"))
      )
    end
  end

  private_class_method def self.search_games_directly(query, token)
    # 英語タイトルは games テーブルの search 機能で直接検索する
    body = <<~BODY
      fields name, platforms.name, genres.name, cover.image_id;
      search "#{sanitize(query)}";
      limit 50;
    BODY

    results = igdb_request("/games", body, token)
    return [] unless results

    results.map do |game|
      game.merge("cover_url" => build_cover_url(game.dig("cover", "image_id")))
    end
  end

  # ===================================================================
  # 共通ヘルパー（private）
  # ===================================================================

  # IGDB APIへのHTTPリクエストを共通化したメソッド
  # 各エンドポイントで同じセットアップが重複しないよう切り出している
  private_class_method def self.igdb_request(path, body, token)
    uri  = URI("#{IGDB_BASE_URL}#{path}")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri).tap do |r|
      r["Client-ID"]     = ENV["IGDB_CLIENT_ID"]
      r["Authorization"] = "Bearer #{token}"
      r.body             = body
    end

    res = http.request(req)
    unless res.code == "200"
      Rails.logger.error "IGDB error [#{path}] #{res.code}: #{res.body}"
      return nil
    end

    JSON.parse(res.body)
  end

  # カバー画像のURLを組み立てる
  # image_id が nil の場合（カバーなし）は nil を返す
  private_class_method def self.build_cover_url(image_id)
    return nil unless image_id
    "https://images.igdb.com/igdb/image/upload/t_cover_big/#{image_id}.jpg"
  end

  # 日本語（ひらがな・カタカナ・漢字）を含むかどうかを判定する
  private_class_method def self.contains_japanese?(text)
    text =~ /[\p{Hiragana}\p{Katakana}\p{Han}]/
  end

  # クエリ文字列のサニタイズ
  # 【許可リスト方式】で安全な文字のみを残す
  # - 許可：日本語（ひらがな・カタカナ・漢字）、英数字、スペース
  # - 除去：記号類（クエリインジェクション対策）
  # 例）"FF*; fields password;" → "FF fields password"（記号が除去される）
  private_class_method def self.sanitize(query)
    query.gsub(/[^\p{Hiragana}\p{Katakana}\p{Han}a-zA-Z0-9\s]/, "").strip
  end

  # ===================================================================
  # 認証（private）
  # ===================================================================

  # TwitchのOAuth2でアクセストークンを取得する
  # 毎回取得するとAPIコールが増えるため、1時間Railsキャッシュに保持して使い回す
  private_class_method def self.get_token
    Rails.cache.fetch("igdb_token", expires_in: 1.hour) do
      res = Net::HTTP.post_form(
        URI("https://id.twitch.tv/oauth2/token"),
        client_id:     ENV["IGDB_CLIENT_ID"],
        client_secret: ENV["IGDB_CLIENT_SECRET"],
        grant_type:    "client_credentials"
      )
      JSON.parse(res.body)["access_token"]
    end
  end
end