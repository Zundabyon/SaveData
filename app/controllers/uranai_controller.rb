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
    connection = Faraday.new(url: "http://ai_service:8000") do |f|
      f.request :json
      f.response :json
    end

    # FastAPIの/api/fortuneにPOSTリクエストを送る
    # params[:game_title]はビューのフォームから送られてくるゲームタイトル
    # current_user.nameはDeviseのログイン中ユーザーの名前
    response = connection.post("/api/fortune") do |req|
      req.body = {
        game_title: params[:game_title],
        user_name: current_user.name
      }
    end

    # FastAPIからの返答をJSONとしてブラウザに返す
    render json: response.body
  end
end