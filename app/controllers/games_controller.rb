class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: %i[show edit update destroy confirm_destroy]
  before_action :authorize_user!, only: %i[show edit update destroy confirm_destroy]

  # 詳細画面
  def show
  end

  def new
    @game = current_user.games.new
  end

  def edit
  end

  def create
    @game = current_user.games.new(game_params)
    if @game.save
      redirect_to dashboard_path, notice: "ゲームのおもいでをセーブしました"
    else
      render :new, status: :unprocessable_entity
    end
  end

def update
  if @game.update(game_params)
    redirect_to dashboard_path, notice: "ゲームの思い出を更新しました"
  else
    render :edit, status: :unprocessable_entity
  end
end


  # 削除確認画面
  def confirm_destroy
  end

  def destroy
    @game.destroy!
    redirect_to dashboard_path, notice: "ゲームのおもいでを削除しました", status: :see_other
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  # 自分のゲームかチェック
  def authorize_user!
    unless @game.user_id == current_user.id
      redirect_to dashboard_path, alert: "アクセス権限がありません"
    end
  end

  def game_params
    params.require(:game).permit(
      :title,
      :hardware,
      :genre,
      :played_age,
      :memo,
      :difficulty,
      :fun
    )
  end
end
