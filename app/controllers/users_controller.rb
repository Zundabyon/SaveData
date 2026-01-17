class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show ]
  # GET /users or /users.json
  def index
    @user = current_user
    @games = @user.games.order(:played_year)
  end
  # indexアクションは、現在ログインしているユーザーの情報と
  # そのユーザーに関連するゲームの一覧を取得し、ビューに渡す役割を果たす
  # current_userメソッドは、Deviseによって提供され、現在ログインしているユーザーを返す
  # @user変数に現在のユーザー情報を格納し、ビューで使用できるようにする
  # @games変数には、現在のユーザーに関連するゲームの一覧を
  # played_year（プレイした年）で昇順に並べ替えたものを格納する
  # これにより、ビューでユーザーのゲーム履歴を表示できるようになる 

  # GET /users/1 or /users/1.json
  def show
  end
  # showアクションは、特定のユーザーの詳細情報を表示するために使用される
  # before_actionコールバックによってset_userメソッドが実行され、
  # @user変数に該当するユーザー情報が格納される
  # ビューでは、この@user変数を使用してユーザーの詳細情報を表示することができる

  private
    def set_user
      @user = User.find(params[:id])
    end
    # set_userメソッドは、指定されたIDに基づいてユーザーをデータベースから取得し、
    # @userインスタンス変数に格納する
    # @user変数は、ビューで使用され、特定のユーザーの情報を表示するために利用される
    # User.find(params[:id])は、URLパラメータから渡されたIDを使用して
    # 対応するユーザーをデータベースから検索する

    # これにより、showアクションで特定のユーザー情報を表示できるようになる

    # before_actionコールバックを使用して、showアクションが実行される前に
    # set_userメソッドが呼び出されるようにしている
end
