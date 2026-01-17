class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show ]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

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
