class UsersController < ApplicationController
  def show
    @user  = current_user.find(params[:id])
    @games = current_user.games
  end
end
