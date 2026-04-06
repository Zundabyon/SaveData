class Api::AiController < ApplicationController
  skip_before_action :verify_authenticity_token # APIリクエストはCSRFトークンを送らないため、これをスキップする

  def recommend
    # FastAPIに向けてリクエストを送る
    # Docker内ではlocalhost→サービス名で繋がる
    conn = Faraday.new(url: "http://ai_service:8000") do |f|
      f.request :json
      f.response :json
    end

    response = conn.post("/api/recommend") do |req|
      req.body = {
        game_title: params[:game_title],
        review: params[:review]
      }
    end

    render json: response.body
  end
end
