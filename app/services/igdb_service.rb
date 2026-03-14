require 'open-uri'
require 'net/http'
require 'json'

class IgdbService

  # ゲームを検索する
  def self.search(query)
    Rails.logger.info "IGDB search called with query: #{query}"
    token = get_token  # まず入場チケットをもらう
    Rails.logger.info "IGDB token obtained: #{token.present? ? 'YES' : 'NO'}"

    # IGDBに「このゲーム教えて」と送る
    uri = URI("https://api.igdb.com/v4/games")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Client-ID"]    = ENV["IGDB_CLIENT_ID"]
    request["Authorization"] = "Bearer #{token}"
    request.body = <<~BODY
      search "#{query.gsub('"', '')}";
      fields name, platforms.name, genres.name, cover.image_id;
      limit 30;
    BODY

    Rails.logger.info "IGDB request body: #{request.body}"
    response = http.request(request)
    Rails.logger.info "IGDB response code: #{response.code}"
    Rails.logger.info "IGDB response body: #{response.body}"

    games = JSON.parse(response.body)

    # 画像URLを組み立てて追加する
    games.map do |game|
      if game["cover"]
        image_id = game["cover"]["image_id"]
        game["cover_url"] = "https://images.igdb.com/igdb/image/upload/t_cover_big/#{image_id}.jpg"
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
