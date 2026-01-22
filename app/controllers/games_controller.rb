class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
    @game = current_user.games.new
  end

  def create
  @game = current_user.games.new(game_params)
  if @game.save
    redirect_to dashboard_path, notice: "ゲームを登録しました"
  else
    # ここを変更
    flash.now[:alert] = @game.errors.full_messages.join(", ")
    render :new
  end
end


  private

  def game_params
    params.require(:game).permit(:title, :hardware, :genre, :played_age, :fun, :difficulty, :memo)
  end
end
