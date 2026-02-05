class DashboardsController < ApplicationController
  before_action :authenticate_user!

def show
  @user  = current_user
  @games = @user.games
                .order(:played_age)

  Rails.logger.info "DASHBOARD GAMES: #{@games.pluck(:id, :title, :played_age)}"
end

end
