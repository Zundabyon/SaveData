class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @games = @user.games
    @favorite_genre = @user.games.group(:genre).order('count_all DESC').count.first&.first || "未設定"
  end
end