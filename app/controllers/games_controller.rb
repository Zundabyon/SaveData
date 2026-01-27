class GamesController < ApplicationController
  def create
    @game = Game.new(game_params)

    if @game.save
      render turbo_stream: turbo_stream.prepend(
        "games",
        partial: "games/game",
        locals: { game: @game }
      )
    else
      render :new
    end
  end

  def update
    @game = Game.find(params[:id])

    if @game.update(game_params)
      flash.now[:notice] = "更新しました"

      render turbo_stream: [
        turbo_stream.replace(@game,
          partial: "games/game",
          locals: { game: @game }
        ),
        turbo_stream.update("modal", "")
      ]
    else
      render :edit
    end
  end

  def confirm_destroy
    @game = Game.find(params[:id])
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    flash.now[:notice] = "削除しました"

    render turbo_stream: [
      turbo_stream.remove(@game),
      turbo_stream.update("modal", "")
    ]
  end

  private

  def game_params
    params.require(:game).permit(:title, :genre, :hardware, :played_age, :fun, :difficulty, :memo)
  end
end
