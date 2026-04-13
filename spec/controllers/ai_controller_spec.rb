require 'rails_helper'

RSpec.describe "Api::Ais", type: :request do
  let(:user) { create(:user) }

  before { sign_in user, scope: :user }

  describe "POST /api/ai/recommend" do
    # FastAPIのURL（コントローラーと同じ値）
    let(:ai_url) { "http://ai_service:8000" }

    before do
      # FastAPIへのリクエストをモック化
      # .with でgame_titleとreviewの両方が送られているか検証できる
      stub_request(:post, "#{ai_url}/api/recommend")
        .with(
          body: {
            game_title: "ファイナルファンタジーVII",
            review: "最高のRPGです"
          }
        )
        .to_return(
          status: 200,
          body: {
            recommendations: [
              { title: "ファイナルファンタジーVI", reason: "同じ世界観が楽しめる" },
              { title: "クロノトリガー",           reason: "RPGの名作" },
              { title: "ドラゴンクエストV",        reason: "感動のストーリー" }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it "FastAPIにgame_titleとreviewが送られること" do
      post api_ai_recommend_path, params: {
        game_title: "ファイナルファンタジーVII",
        review: "最高のRPGです"
      }
      # WebMockが .with のパラメータと一致しないとエラーになる
      # → パラメータが正しく送られている証明になる
      expect(response).to have_http_status(:success)
    end

    it "recommendationsが3件返ってくること" do
      post api_ai_recommend_path, params: {
        game_title: "ファイナルファンタジーVII",
        review: "最高のRPGです"
      }
      json = JSON.parse(response.body)
      expect(json["recommendations"].length).to eq(3)
    end

    it "レスポンスにtitleとreasonが含まれること" do
      post api_ai_recommend_path, params: {
        game_title: "ファイナルファンタジーVII",
        review: "最高のRPGです"
      }
      json = JSON.parse(response.body)
      expect(json["recommendations"][0]["title"]).to eq("ファイナルファンタジーVI")
      expect(json["recommendations"][0]["reason"]).to eq("同じ世界観が楽しめる")
    end
  end
end
