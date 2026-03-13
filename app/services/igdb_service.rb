require 'open-uri'
require 'net/http'
require 'json'

class IgdbService

  # ゲームを検索する
  def self.search(query)
    token = get_token  # まず入場チケットをもらう

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
      limit 5;
    BODY

    response = http.request(request)
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
      uri = URI("https://id.twitch.tv/oauth2/token")
      response = Net::HTTP.post_form(uri, {
        client_id:     ENV["IGDB_CLIENT_ID"],
        client_secret: ENV["IGDB_CLIENT_SECRET"],
        grant_type:    "client_credentials"
      })
      JSON.parse(response.body)["access_token"]
    end
  end
end
