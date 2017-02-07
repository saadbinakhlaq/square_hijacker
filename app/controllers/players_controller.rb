class PlayersController < ApplicationController
  include ApplicationHelper

  def new
    @game = game
    @player = Player.new
  end

  def create
    res = game.add_player(current_user, player_name)

    if res[:success]
      player = res[:result]

      if game.players_count == game.min_players
        game.start!
        ActionCable.server.broadcast "game_channel_#{game.id}",
                                      enable_squares: true
      end
      ActionCable.server.broadcast "game_channel_#{game.id}",
                                    player_joined: true,
                                    joining_player_id: player.id,
                                    joining_player_name: player.name,
                                    joining_player_colour: time_to_hex(player.joined.to_i, player.id)

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