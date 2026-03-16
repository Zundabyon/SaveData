class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user  = current_user
    @games = @user.games
                  .order(:played_age)
    
    if params[:title].present?
      @games = @games.where("title ILIKE ?", "%#{params[:title]}%")
    end
  end
end
