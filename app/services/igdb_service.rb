require 'open-uri'
require 'net/http'
require 'json'

class IgdbService

  # 日本語を含むクエリかどうかを判定
  def self.contains_japanese?(text)
    # ひらがな・カタカナ・漢字を含むかチェック
    text =~ /[\p{Hiragana}\p{Katakana}\p{Han}]/
  end

  # ゲームを検索する
  def self.search(query)
    Rails.logger.info "IGDB search called with query: #{query}"
    token = get_token  # まず入場チケットをもらう
    Rails.logger.info "IGDB token obtained: #{token.present? ? 'YES' : 'NO'}"

    if contains_japanese?(query)
      # 日本語を含む場合：alternative_namesを使って検索
      Rails.logger.info "Using alternative_names search for Japanese query"
      search_with_alternative_names(query, token)
    else
      # 英語の場合：従来のgames検索
      Rails.logger.info "Using games search for English query"
      search_games_directly(query, token)
    end
  end

  # alternative_namesを使って日本語検索
  def self.search_with_alternative_names(query, token)
    # まずalternative_namesで検索
    uri = URI("https://api.igdb.com/v4/alternative_names")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Client-ID"]    = ENV["IGDB_CLIENT_ID"]
    request["Authorization"] = "Bearer #{token}"
    request.body = <<~BODY
      fields game.name, game.cover.image_id, game.platforms.name, game.genres.name, name;
      where name ~ *"#{query.gsub('"', '')}"*;
      limit 100;
    BODY

    Rails.logger.info "IGDB alternative_names request body: #{request.body}"
    response = http.request(request)
    Rails.logger.info "IGDB alternative_names response code: #{response.code}"

    alternative_names = JSON.parse(response.body)
    Rails.logger.info "Found #{alternative_names.length} alternative names"
    Rails.logger.info "Alternative names response: #{response.body}"

    # alternative_namesからゲーム情報を抽出
    games = alternative_names.map do |alt|
      game_data = alt["game"]
      next nil unless game_data

      # 構造をフラットに
      {
        "id" => game_data["id"],
        "name" => game_data["name"],
        "cover" => game_data["cover"],
        "platforms" => game_data["platforms"],
        "genres" => game_data["genres"],
        "alternative_name" => alt["name"]
      }
    end.compact

    Rails.logger.info "Extracted #{games.length} games from alternative names"

    # 画像URLを組み立てて追加する
    games.map do |game|
      Rails.logger.info "Processing game: #{game['name']}, cover: #{game['cover']&.inspect}"
      if game["cover"]
        image_id = game["cover"]["image_id"]
        game["cover_url"] = "https://images.igdb.com/igdb/image/upload/t_cover_big/#{image_id}.jpg"
        Rails.logger.info "Added cover_url: #{game['cover_url']}"
      else
        Rails.logger.info "No cover for game: #{game['name']}"
      end
      game
    end
  end

  # 従来のgames直接検索（英語用）
  def self.search_games_directly(query, token)
    uri = URI("https://api.igdb.com/v4/games")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Client-ID"]    = ENV["IGDB_CLIENT_ID"]
    request["Authorization"] = "Bearer #{token}"
    request.body = <<~BODY
      fields name, platforms.name, genres.name, cover.image_id;
      search "#{query.gsub('"', '')}";
      limit 50;
    BODY

    Rails.logger.info "IGDB games request body: #{request.body}"
    response = http.request(request)
    Rails.logger.info "IGDB games response code: #{response.code}"
    Rails.logger.info "IGDB games response body length: #{response.body.length}"
    
    if response.code != "200"
      Rails.logger.error "IGDB API error: #{response.code} - #{response.body}"
      return []
    end
    
    games = JSON.parse(response.body)
    Rails.logger.info "IGDB search returned #{games.length} games"

    # 画像URLを組み立てて追加する
    games.map do |game|
      Rails.logger.info "Processing game: #{game['name']}, cover: #{game['cover']&.inspect}"
      if game["cover"]
        image_id = game["cover"]["image_id"]
        game["cover_url"] = "https://images.igdb.com/igdb/image/upload/t_cover_big/#{image_id}.jpg"
        Rails.logger.info "Added cover_url: #{game['cover_url']}"
      else
        Rails.logger.info "No cover for game: #{game['name']}"
      end
      game
    end
  end

  # 入場チケット（アクセストークン）を取得する
  # 1時間キャッシュして使い回す（毎回取りに行かなくていい）
  def self.get_token
    Rails.cache.fetch("igdb_token", expires_in: 1.hour) do
      Rails.logger.info "Getting new IGDB token"
      Rails.logger.info "IGDB_CLIENT_ID: #{ENV['IGDB_CLIENT_ID']&.present? ? 'SET' : 'NOT SET'}"
      Rails.logger.info "IGDB_CLIENT_SECRET: #{ENV['IGDB_CLIENT_SECRET']&.present? ? 'SET' : 'NOT SET'}"
      uri = URI("https://id.twitch.tv/oauth2/token")
      response = Net::HTTP.post_form(uri, {
        client_id:     ENV["IGDB_CLIENT_ID"],
        client_secret: ENV["IGDB_CLIENT_SECRET"],
        grant_type:    "client_credentials"
      })
      Rails.logger.info "Token response code: #{response.code}"
      Rails.logger.info "Token response body: #{response.body}"
      JSON.parse(response.body)["access_token"]
    end
  end
end
