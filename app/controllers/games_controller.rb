class GamesController < ApplicationController
  def index
    @games = Game.all.ordered.paginate(page: params[:page])
  end

  def new
    @game = Game.new
  end

  def show
    @game = game
    @player = game.current_player(current_user)
  end

  def create
    @game = Game.new(board_size: board_size,
                     min_players: min_players,
                     max_players: max_players,
                     blockage_time: blockage_time)

    (1..board_size).each { |i| @game.squares.build(number: i, game: @game) }

    if @game.save
      @game.add_player(current_user, player_name)
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  def join
    if game.players_count == game.max_players
      flash[:alert] = 'max players reached for the game'
      render :index
    elsif game.player_in_game?(current_user.id)
      redirect_to game_path(game)
    else
      redirect_to new_game_player_path(game)
    end
  end

  private

  def game_params
    params.require(:game).permit(:player_name,
                                 :board_size,
                                 :min_players,
                                 :max_players,
                                 :blockage_time)
  end

  def board_size
    game_params[:board_size] || 4
  end

  def min_players
    game_params[:min_players] || 2
  end

  def max_players
    game_params[:max_players] || 4
  end

  def player_name
    game_params[:player_name]
  end

  def blockage_time
    game_params[:blockage_time] || 3
  end

  def game
    @_game ||= Game.includes(:squares, :players).find(params[:id])
  end
end