class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: %i[show edit update destroy confirm_destroy remove_cover_image]
  before_action :authorize_user!, only: %i[show edit update destroy confirm_destroy remove_cover_image]

  def index
    @games = current_user.games.order(created_at: :desc)
  end

  def show
  end

  def new
    @game = current_user.games.new
  end

  def edit
  end

  def igdb_search
    query = params[:q].to_s.strip
    Rails.logger.info "IGDB search action called with query: '#{query}'"
    return head :ok if query.blank?

    @games = IgdbService.search(query)
    Rails.logger.info "IGDB search results: #{@games.length} games found"
    render partial: "games/igdb_results", locals: { games: @games }
  end

  def create
    @game = current_user.games.new(game_params)

    if params[:game][:igdb_cover_url].present?
      url = params[:game][:igdb_cover_url]
      @game.cover_image.attach(
        io: URI.open(url),
        filename: "igdb_cover.jpg",
        content_type: "image/jpeg"
      )
    end

    if @game.save
      Rails.logger.info "Game saved! ID: #{@game.id}, Image attached: #{@game.cover_image.attached?}"
      redirect_to dashboard_path, notice: "ゲームのおもいでをセーブしました"
    else
      Rails.logger.error "Game save failed: #{@game.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # チェックボックスで削除フラグが立っている場合
    @game.cover_image.purge if params[:game][:remove_cover_image] == "1"

    if params[:game][:igdb_cover_url].present?
      url = params[:game][:igdb_cover_url]
      @game.cover_image.attach(
        io: URI.open(url),
        filename: "igdb_cover.jpg",
        content_type: "image/jpeg"
      )
    end

    if @game.update(game_params)
      Rails.logger.info "Game updated! Image attached: #{@game.cover_image.attached?}"
      redirect_to dashboard_path, notice: "ゲームの思い出を更新しました"
    else
      Rails.logger.error "Game update failed: #{@game.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
    @game = current_user.games.find(params[:id])
    @mode = :confirm_delete
  end

  def destroy
    @game.destroy!
    redirect_to dashboard_path, notice: "ゲームのおもいでを削除しました", status: :see_other
  end

  def remove_cover_image
    @game.cover_image.purge
    redirect_to edit_game_path(@game), notice: "カバー画像を削除しました"
  end

  private

  def set_game
    @game = current_user.games.find(params[:id])
  end

  def authorize_user!
    unless @game.user_id == current_user.id
      redirect_to dashboard_path, alert: "アクセス権限がありません"
    end
  end

  def game_params
    params.require(:game).permit(
      :title,
      :hardware,
      :genre,
      :played_age,
      :memo,
      :cover_image,
      :difficulty,
      :fun,
      :remove_cover_image,
      :igdb_cover_url
    )
  end
end
