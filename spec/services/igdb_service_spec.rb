require 'rails_helper'

RSpec.describe IgdbService do
  # ─────────────────────────────────────────
  # 各テストの前にTwitchのトークン取得をモック化する
  # 全テスト共通で必要なので一番外のbeforeに書く
  # ─────────────────────────────────────────
  before do
    # Twitchのトークン取得をモック化
    # IgdbService.searchを呼ぶと必ずここを通るのでモックが必須
    stub_request(:post, "https://id.twitch.tv/oauth2/token")
      .to_return(
        status: 200,
        body: { access_token: "fake_token", expires_in: 3600 }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # Railsキャッシュをクリア（前のテストのトークンが残らないように）
    Rails.cache.clear
  end

  describe ".search" do
    context "英語で検索したとき" do
      before do
        # IGDB APIへのリクエストをモック化
        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(
            status: 200,
            body: [
              {
                "id" => 1,
                "name" => "Final Fantasy VII",
                "cover" => { "image_id" => "abc123" },
                "platforms" => [ { "name" => "PlayStation" } ],
                "genres" => [ { "name" => "RPG" } ]
              }
            ].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "ゲームが返ってくること" do
        results = IgdbService.search("Final Fantasy VII")
        expect(results).not_to be_empty
      end

      it "nameが含まれること" do
        results = IgdbService.search("Final Fantasy VII")
        expect(results.first["name"]).to eq("Final Fantasy VII")
      end

      it "cover_urlが付加されること" do
        results = IgdbService.search("Final Fantasy VII")
        expect(results.first["cover_url"]).to include("abc123")
      end
    end

    context "日本語で検索したとき" do
      before do
        # DeepL APIをモック化（日本語→英語翻訳）
        stub_request(:post, "https://api-free.deepl.com/v2/translate")
          .to_return(
            status: 200,
            body: {
              translations: [ { text: "Final Fantasy VII" } ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # alternative_names検索をモック化（日本語タイトル検索）
        stub_request(:post, "https://api.igdb.com/v4/alternative_names")
          .to_return(
            status: 200,
            body: [
              {
                "name" => "ファイナルファンタジーVII",
                "game" => {
                  "id" => 1,
                  "name" => "Final Fantasy VII",
                  "cover" => { "image_id" => "abc123" },
                  "platforms" => [ { "name" => "PlayStation" } ],
                  "genres" => [ { "name" => "RPG" } ]
                }
              }
            ].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # 英語翻訳後のIGDB検索もモック化
        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(
            status: 200,
            body: [].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "ゲームが返ってくること" do
        results = IgdbService.search("ファイナルファンタジーVII")
        expect(results).not_to be_empty
      end

      it "重複が除去されること" do
        results = IgdbService.search("ファイナルファンタジーVII")
        ids = results.map { |g| g["id"] }
        expect(ids).to eq(ids.uniq)
      end
    end

    context "IGDBがエラーを返したとき" do
      before do
        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(status: 500, body: "Internal Server Error")

        stub_request(:post, "https://api.igdb.com/v4/alternative_names")
          .to_return(status: 500, body: "Internal Server Error")

        stub_request(:post, "https://api-free.deepl.com/v2/translate")
          .to_return(status: 500, body: "Internal Server Error")
      end

      it "空配列が返ってくること（エラーでも落ちない）" do
        results = IgdbService.search("Final Fantasy")
        expect(results).to eq([])
      end
    end

    context "DeepLが翻訳に成功したとき" do
      before do
        stub_request(:post, "https://api-free.deepl.com/v2/translate")
          .to_return(
            status: 200,
            body: {
              translations: [ { text: "Final Fantasy VII" } ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        stub_request(:post, "https://api.igdb.com/v4/alternative_names")
          .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(
            status: 200,
            body: [
              {
                "id" => 1,
                "name" => "Final Fantasy VII",
                "cover" => { "image_id" => "abc123" }
              }
            ].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "翻訳結果を使って英語検索が実行されること" do
        results = IgdbService.search("ファイナルファンタジーVII")
        expect(results).not_to be_empty
      end
    end

    context "DeepLがエラーを返したとき" do
      before do
        stub_request(:post, "https://api-free.deepl.com/v2/translate")
          .to_return(status: 403, body: "Forbidden")

        stub_request(:post, "https://api.igdb.com/v4/alternative_names")
          .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it "翻訳失敗してもエラーにならず空配列が返ること" do
        results = IgdbService.search("ファイナルファンタジーVII")
        expect(results).to eq([])
      end
    end

    context "DeepLへの接続が失敗したとき" do
      before do
        # 例外を発生させてrescueブロックを通す
        stub_request(:post, "https://api-free.deepl.com/v2/translate")
          .to_raise(StandardError.new("connection failed"))

        stub_request(:post, "https://api.igdb.com/v4/alternative_names")
          .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

        stub_request(:post, "https://api.igdb.com/v4/games")
          .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it "例外が発生してもエラーにならず空配列が返ること" do
        results = IgdbService.search("ファイナルファンタジーVII")
        expect(results).to eq([])
      end
    end
  end
end
