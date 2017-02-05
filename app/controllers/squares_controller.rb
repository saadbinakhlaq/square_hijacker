class SquaresController < ApplicationController
  include ApplicationHelper

  def claim
    if game.over?
      flash[:alert] = 'game has ended'
      return redirect_to game_path(game)
    end

    unless game.started?
      flash[:alert] = 'game has not started yet'
      return redirect_to game_path(game)
    end

    number_of_squares_left = game.squares_count
    res = square.claim(player_id)
    if res[:success]
      if number_of_squares_left - 1 == 0
        game.end!
        game.assign_winner
        ActionCable.server.broadcast "game_channel_#{game.id}",
                                      game_ends: true,
                                      winner_name: game.winner.name
      end
      
      ActionCable.server.broadcast "game_channel_#{game.id}",
                                   block: true,
                                   unclaimed_squares: game.unclaimed_squares,
                                   disabled_square_id: square.id,
                                   disabled_square_colour: time_to_hex(game.square_claimed_by(square.id).joined.to_i)
    else
      flash[:alert] = res[:result]
      redirect_to game_path(game)
    end
  end

  private

  def square_params
    params.require(:square).permit(:player_id)
  end

  def game
    @_game ||= Game.includes(:players, :squares).find(params[:game_id])
  end

  def square
    squares = game.squares.find { |square| square.id == params[:id].to_i }
  end

  def player_id
    square_params[:player_id]
  end
end