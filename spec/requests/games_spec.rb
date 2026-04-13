require 'rails_helper'

RSpec.describe "Games", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:game) { create(:game, user: user) }
  let(:browser_headers) do
    {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    }
  end

  before do
    sign_in user, scope: :user
    ActionController::Base.allow_forgery_protection = false
  end

  after do
    ActionController::Base.allow_forgery_protection = true
  end

  describe "GET /dashboard" do
    it "200を返す" do
      get dashboard_path, headers: browser_headers
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /games/:id/edit" do
    it "200を返す" do
      get edit_game_path(game), headers: browser_headers
      expect(response).to have_http_status(:success)
    end

    context "他人のゲームにアクセスしたとき" do
      let(:other_game) { create(:game, user: other_user) }

      it "404が返ること" do
        get edit_game_path(other_game), headers: browser_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /games/igdb_search" do
    context "クエリが空のとき" do
      it "200を返す" do
        get igdb_search_games_path, params: { q: "" }, headers: browser_headers
        expect(response).to have_http_status(:success)
      end
    end

    context "クエリがあるとき" do
      before do
        stub_request(:post, "https://id.twitch.tv/oauth2/token")
          .to_return(
            status: 200,
            body: { access_token: "fake_token" }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(
            status: 200,
            body: [
              { "id" => 1, "name" => "Final Fantasy VII", "cover" => { "image_id" => "abc123" } }
            ].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        Rails.cache.clear
      end

      it "200を返す" do
        get igdb_search_games_path, params: { q: "Final Fantasy" }, headers: browser_headers
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /games" do
    let(:valid_params) do
      {
        game: {
          title: "Final Fantasy VII",
          hardware: Game::HARDWARE_OPTIONS.first,
          genre: Game::GENRE_OPTIONS.first,
          played_age: Game::PLAYED_AGE_OPTIONS.first[1]
        }
      }
    end

    context "通常の登録のとき" do
      it "ゲームが作成されること" do
        expect {
          post games_path, params: valid_params, headers: browser_headers
        }.to change(Game, :count).by(1)
      end

      it "dashboardにリダイレクトされること" do
        post games_path, params: valid_params, headers: browser_headers
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "バリデーションエラーのとき" do
      it "422を返す" do
        post games_path, params: { game: { title: "" } }, headers: browser_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /games/:id" do
    context "正常に更新できるとき" do
      it "dashboardにリダイレクトされること" do
        patch game_path(game), params: { game: { title: "更新されたタイトル" } }, headers: browser_headers
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "バリデーションエラーのとき" do
      it "422を返す" do
        patch game_path(game), params: { game: { title: "" } }, headers: browser_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /games/:id/confirm_destroy" do
    it "200を返す" do
      get confirm_destroy_game_path(game), headers: browser_headers
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /games/:id" do
    it "ゲームが削除されること" do
      game
      expect {
        delete game_path(game), headers: browser_headers
      }.to change(Game, :count).by(-1)
    end

    it "dashboardにリダイレクトされること" do
      delete game_path(game), headers: browser_headers
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe "DELETE /games/:id/remove_cover_image" do
    it "editページにリダイレクトされること" do
      delete remove_cover_image_game_path(game), headers: browser_headers
      expect(response).to redirect_to(edit_game_path(game))
    end
  end
  describe "IGDBカバー画像付きでゲームを登録するとき" do
  before do
    # URI.openをモック化（外部URLへのアクセスを防ぐ）
    allow(URI).to receive(:open).and_return(
      StringIO.new("fake image data")
    )
  end

  it "ゲームが作成されること" do
    expect {
      post games_path, params: {
        game: {
          title: "Final Fantasy VII",
          hardware: Game::HARDWARE_OPTIONS.first,
          genre: Game::GENRE_OPTIONS.first,
          played_age: Game::PLAYED_AGE_OPTIONS.first[1],
          igdb_cover_url: "https://images.igdb.com/igdb/image/upload/t_cover_big/abc123.jpg"
        }
      }, headers: browser_headers
    }.to change(Game, :count).by(1)
  end
 end

  describe "IGDBカバー画像付きでゲームを更新するとき" do
    before do
      allow(URI).to receive(:open).and_return(
        StringIO.new("fake image data")
      )
    end

    it "dashboardにリダイレクトされること" do
      patch game_path(game), params: {
        game: {
          title: "更新されたタイトル",
          igdb_cover_url: "https://images.igdb.com/igdb/image/upload/t_cover_big/abc123.jpg"
        }
      }, headers: browser_headers
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe "他人のゲームを操作しようとしたとき" do
    let(:other_game) { create(:game, user: other_user) }

    it "404が返ること" do
      patch game_path(other_game), params: {
        game: { title: "不正な更新" }
      }, headers: browser_headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
