class PlayersController < ApplicationController
  def new
    @game = game
    @player = Player.new
  end

  def create
    res = game.add_player(current_user, player_name)

    if res[:success]
      redirect_to game_path(game)
    else
      flash[:alert] = res[:result]
      redirect_to games_path
    end
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

  def game
    @_game ||= Game.find params[:game_id]
  end

  def player_name
    player_params[:name]
  end
end