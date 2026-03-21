class UsersController < ApplicationController
  def show
    @user  = User.find(params[:id])
    @games = current_user.games
  end
end
