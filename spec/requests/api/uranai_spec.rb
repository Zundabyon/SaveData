require 'rails_helper'

RSpec.describe "Uranais", type: :request do
  let(:user) { create(:user) }

  before { sign_in user, scope: :user }

  describe "GET /uranai/index" do
    it "200を返す" do
      get uranai_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /uranai/predict" do
    let(:ai_url) { ENV.fetch("AI_SERVICE_URL", "http://ai_service:8000") }

    before do
      ActionController::Base.allow_forgery_protection = false

      stub_request(:post, "#{ai_url}/api/fortune")
        .to_return(
          status: 200,
          body: {
            predictions: [
              { title: "ファイナルファンタジーVI", reason: "壮大なストーリーが魅力" },
              { title: "クロノトリガー", reason: "時間旅行の冒険が待っている" },
              { title: "ドラゴンクエストV", reason: "感動の親子三代の物語" }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    after do
      ActionController::Base.allow_forgery_protection = true
    end

    it "200を返す" do
      post uranai_predict_path, params: { game_title: "ファイナルファンタジーVII" }
      expect(response).to have_http_status(:success)
    end

    it "AIのレスポンスが返ってくる" do
      post uranai_predict_path, params: { game_title: "ファイナルファンタジーVII" }
      json = JSON.parse(response.body)
      expect(json["predictions"].length).to eq(3)
      expect(json["predictions"][0]["title"]).to eq("ファイナルファンタジーVI")
    end
  end
end
