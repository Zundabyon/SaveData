class IgdbService
  IGDB_BASE_URL = "https://api.igdb.com/v4"

  # ===================================================================
  # 公開API
  # ===================================================================

  # ゲームを検索する（日本語・英語を自動判定して振り分け）
  # 日本語の場合は alternative_names 検索 + 英語翻訳して英語検索も実行する
  def self.search(query)
    token = get_token
    if contains_japanese?(query)
      results = search_by_alternative_names(query, token)

      # 日本語→英語に変換して英語検索も実行（IGDBに日本語alternative_nameが
      # 登録されていないゲームを拾うための補完）
      english_query = translate_to_english(query)
      results += search_games_directly(english_query, token) if english_query

      results.uniq { |g| g["id"] }
    else
      search_games_directly(query, token)
    end
  end

  # ===================================================================
  # 検索ロジック（private）
  # ===================================================================

  # 日本語検索：alternative_names テーブルに複数戦略でアクセスする
  private_class_method def self.search_by_alternative_names(query, token)
    sanitized = sanitize(query)
    results   = []

    # 戦略1: 入力そのままで部分一致検索
    results += alt_names_partial_search(sanitized, token)

    # 戦略2: スペース除去版（「ダーク ソウル」→「ダークソウル」にも対応）
    no_space = sanitized.delete(" ")
    results  += alt_names_partial_search(no_space, token) if no_space != sanitized

    # IDで重複除去 → カバーURL付加
    build_results(results)
  end

  # 英語検索：複数の戦略を組み合わせてヒット率を上げる
  #
  # 【戦略の組み合わせ理由】
  #   IGDB にはファジー検索がないため、以下3戦略の結果をマージして補完する。
  #
  #   戦略1: 部分一致 (name ~ *"query"*)
  #     → 入力がタイトルの一部でもヒット。
  #       例: "DARK SOULS" → "DARK SOULS III", "DARK SOULS: REMASTERED" 等にヒット。
  #
  #   戦略2: 単語分割 AND 条件検索
  #     → 入力の各単語がタイトルに含まれていればヒット。
  #       部分一致では拾えない「単語が離れているタイトル」を補完する。
  #       例: "DARK SOULS" → name~*"DARK"* & name~*"SOULS"*
  #           → "DARK REBIRTH: SOULS OF CHAOS" のようなタイトルもヒット。
  #
  #   戦略3: スペース除去版で部分一致検索
  #     → スペースなしで入力した場合の逆パターンを補完する。
  #       例: "DARKSOULS" → name ~ *"DARKSOULS"* でヒット。
  #
  private_class_method def self.search_games_directly(query, token)
    sanitized = sanitize(query)
    results   = []

    # 戦略1: 部分一致検索
    results += partial_match_search(sanitized, token)

    # 戦略2: 複数単語をAND条件で検索（単語が離れているタイトルを補完）
    words   = sanitized.split
    results += word_and_search(words, token) if words.size >= 2

    # 戦略3: スペース除去版で部分一致検索（逆パターン補完）
    no_space = sanitized.delete(" ")
    results  += partial_match_search(no_space, token) if no_space != sanitized

    # IDで重複除去 → カバーURL付加
    build_results(results)
  end

  # ===================================================================
  # 検索クエリビルダー（private）
  # ===================================================================

  # 部分一致検索（name ~ *"query"*）
  private_class_method def self.partial_match_search(query, token)
    body = <<~BODY
      fields name, platforms.name, genres.name, cover.image_id;
      where name ~ *"#{query}"*;
      limit 50;
    BODY
    igdb_request("/games", body, token) || []
  end

  # 単語分割 AND 条件検索（"DARK" & "SOULS" 両方を含むゲームを取得）
  # → "DARK SOULS", "DARK SOULS III" などがヒットする
  private_class_method def self.word_and_search(words, token)
    conditions = words.map { |w| "name ~ *\"#{w}\"*" }.join(" & ")
    body = <<~BODY
      fields name, platforms.name, genres.name, cover.image_id;
      where #{conditions};
      limit 50;
    BODY
    igdb_request("/games", body, token) || []
  end

  # alternative_names での部分一致検索（日本語用）
  private_class_method def self.alt_names_partial_search(query, token)
    body = <<~BODY
      fields game.name, game.cover.image_id, game.platforms.name, game.genres.name, name;
      where name ~ *"#{query}"*;
      limit 100;
    BODY
    results = igdb_request("/alternative_names", body, token) || []

    results.filter_map do |alt|
      next unless alt["game"]
      alt["game"].merge("alternative_name" => alt["name"])
    end
  end

  # ===================================================================
  # 翻訳（private）
  # ===================================================================

  # DeepL APIで日本語クエリを英語に変換する
  # → 変換失敗時は nil を返し、呼び出し元でスキップさせる
  # → .env に DEEPL_API_KEY の設定が必要
  private_class_method def self.translate_to_english(query)
    uri  = URI("https://api-free.deepl.com/v2/translate")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri).tap do |r|
      r["Authorization"] = "DeepL-Auth-Key #{ENV['DEEPL_API_KEY']}"
      r["Content-Type"]  = "application/json"
      r.body = { text: [ query ], source_lang: "JA", target_lang: "EN" }.to_json
    end

    res = http.request(req)
    unless res.code == "200"
      return nil
    end

    JSON.parse(res.body).dig("translations", 0, "text")
  rescue => e
    nil
  end

  # ===================================================================
  # 共通ヘルパー（private）
  # ===================================================================

  # 検索結果の重複除去 & カバーURL付加をまとめて行う
  private_class_method def self.build_results(results)
    results
      .uniq { |g| g["id"] }
      .map  { |g| g.merge("cover_url" => build_cover_url(g.dig("cover", "image_id"))) }
  end

  # IGDB APIへのHTTPリクエストを共通化したメソッド
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

  # カバー画像のURLを組み立てる（image_id が nil の場合は nil を返す）
  private_class_method def self.build_cover_url(image_id)
    return nil unless image_id
    "https://images.igdb.com/igdb/image/upload/t_cover_big/#{image_id}.jpg"
  end

  # 日本語（ひらがな・カタカナ・漢字）を含むかどうかを判定する
  private_class_method def self.contains_japanese?(text)
    text =~ /[\p{Hiragana}\p{Katakana}\p{Han}]/
  end

  # クエリ文字列のサニタイズ（許可リスト方式）
  # 許可: 日本語・英数字・スペース
  # 除去: 記号類（クエリインジェクション対策）
  private_class_method def self.sanitize(query)
    query.gsub(/[^\p{Hiragana}\p{Katakana}\p{Han}a-zA-Z0-9\s]/, "").strip
  end

  # ===================================================================
  # 認証（private）
  # ===================================================================

  # TwitchのOAuth2でアクセストークンを取得する（1時間キャッシュ）
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
