class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
    @game = Game.new
  end

  def create
    @game = current_user.games.build(game_params)
    if @game.save
      redirect_to root_path, notice: "ゲームを記録した"
    else
      Rails.logger.debug @game.errors.full_messages
      render :new, status: :unprocessable_entity
end

  end

  private

def game_params
  params.require(:game).permit(
    :title,
    :hardware,
    :genre,
    :ended_year,
    :fun,
    :difficulty,
    :memo
  )
end

end
