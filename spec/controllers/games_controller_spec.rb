require 'rails_helper'

describe GamesController do
  describe 'POST create' do
    it 'creates a game with given number of squares' do
      user = create(:user)
      sign_in_as(user)

      expect {
        post :create,
              params: { game: { player_name: 'saad' } }
      }.to change{ Game.count }.by(1)

      game = assigns(:game)
      expect(game.players_count).to eq(1)
      expect(game.state).to eq('not_started')
      expect(response.status).to eq(302)
    end
  end

  describe 'PUT join' do
    context 'user has not joined the game' do
      it 'user is directed to players page to enter name' do
        game = create(:game)
        user = create(:user)
        sign_in_as(user)

        put :join,
            params: { id: game.id, game: { user_id: user.id } }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_game_player_path(game))
      end
    end

    context 'user has joined the game' do
      it 'redirects to game' do
        user = create(:user)
        sign_in_as(user)
        game = create(:game)
        player = create(:player, game: game, user: user)

        put :join, params: { id: game.id, game: { user_id: user.id } }
        expect(response).to redirect_to(game_path(game))
      end
    end
  end

  describe 'GET show' do
    context 'player not in the game' do
      it 'redirects with games page' do
        user = create(:user)
        sign_in_as(user)
        game = create(:game)

        get :show, params: { id: game.id }
        expect(response).to redirect_to(games_path)
      end
    end
  end
end