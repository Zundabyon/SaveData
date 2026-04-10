class UranaiController < ApplicationController
  # UranaiControllerは占いに関する機能を提供するコントローラー
  # before_action :authenticate_user!は、
  # ユーザーがログインしていることを確認するためのフィルタ
  # ログインしていないユーザーはこのコントローラーのアクションにアクセスできなくなる
  before_action :authenticate_user!

  # indexアクションは占いのトップページを表示するためのアクション
  # これがないと、/uranai/indexにアクセスしたときにエラーになる
  def index
  end

# predictアクションは占いの結果を予測するためのアクション
# faradayを使って、AIサービスにリクエストを送るためのコードが書かれている
# f.requestとf.responseは、リクエストとレスポンスのフォーマットをJSONにするためのもの
# |f|では、faradayの設定を行うためのブロックが始まる
def predict
  ai_url = ENV.fetch("AI_SERVICE_URL", "http://ai_service:8000")

  connection = Faraday.new(url: ai_url) do |f|
    f.request :json
    f.response :json
  end

  response = connection.post("/api/fortune") do |req|
    req.body = {
      game_title: params[:game_title],
      user_name: current_user.name
    }
  end

  render json: response.body
end
end
