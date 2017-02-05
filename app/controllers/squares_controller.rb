class SquaresController < ApplicationController
  def claim
    unless game.started?
      flash[:alert] = 'game has not started yet'
      return redirect_to game_path(game)
    end

    number_of_squares_left = game.squares_count
    res = square.claim(player_id)
    if res[:success]
      game.end! if number_of_squares_left - 1 == 0
      return redirect_to game_path(game)
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