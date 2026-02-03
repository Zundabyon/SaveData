class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user  = current_user
    @games = @user.games.where.not(played_age: nil).order(:played_age)
  end
end