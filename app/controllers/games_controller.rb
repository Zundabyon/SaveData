# app/controllers/games_controller.rb
class GamesController < ApplicationController
  before_action :set_game, only: %i[edit update destroy]

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    @game = current_user.games.new(game_params)
    if @game.save
      redirect_to dashboard_path, notice: "セーブしました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      redirect_to dashboard_path, notice: "更新セーブしました", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy
    redirect_to dashboard_path, notice: "削除しました"
  end

  private

  def set_game
    @game = Game.find(params[:id])
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
