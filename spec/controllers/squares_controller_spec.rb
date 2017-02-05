require 'rails_helper'

describe SquaresController do
  describe 'PUT claim' do
    context 'game is not started' do
      it 'player cannot claim any square' do
        game = create(:game_with_squares)
        user = create(:user)
        sign_in_as(user)
        player = create(:player, game: game, user: user)
        game.save
        square = game.squares.first
        expect {
          put :claim,
              params: { id: square.id,
                        game_id: game.id,
                        square: { player_id: player.id } }
        }.to change { game.reload.squares_count }.by(0)
        expect(response.status).to eq(302)
      end
    end

    context 'game has started' do
      it 'claims a square for the player' do
        game = create(:game_with_squares, state: 'started')
        user = create(:user)
        player = create(:player, game: game, user: user)
        game.save
        sign_in_as(user)
        square = game.squares.first
        expect {
          put :claim,
              params: { id: square.id,
                        game_id: game.id,
                        square: { player_id: player.id } }
        }.to change { game.reload.squares_count }.by(-1)
        expect(response.status).to redirect_to(game_path(game))
      end
    end

    context 'already claimed' do
      it 'returns to the game with flash message' do
        game = create(:game_with_squares, state: 'started')
        user = create(:user)
        player = create(:player, game: game, user: user)
        game.save
        sign_in_as(user)
        square = game.squares.first
        square.claim(player.id)
        expect {
          put :claim,
              params: { id: square.id,
                        game_id: game.id,
                        square: { player_id: player.id } }
        }.to change { game.reload.squares_count }.by(0)
        expect(response.status).to eq(302)
      end
    end

    context 'final square claim' do
      it 'ends the game' do
        game = create(:game_with_squares, state: 'started')
        user = create(:user)
        player = create(:player, game: game, user: user)
        game.save
        sign_in_as(user)
        last_square = game.squares.last
        game.squares.first(3).each do |square|
          square.claim(player.id)
        end

        expect {
          put :claim,
              params: { id: last_square.id,
                        game_id: game.id,
                        square: { player_id: player.id } }
        }.to change { game.reload.state }.to('ended')
        expect(response.status).to eq(302)
      end
    end
  end
end