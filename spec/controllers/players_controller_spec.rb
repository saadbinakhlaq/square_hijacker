require 'rails_helper'

describe PlayersController do
  describe 'POST create' do
    it 'adds a player to a game and redirects to the game' do
      game = create(:game)
      user = create(:user)

      sign_in_as(user)
      expect {
        post :create,
             params: { game_id: game.id, player: { name: 'saad' } }

        expect(response).to redirect_to(game_path(game))
      }.to change { Player.count }.by(1)
    end
  end
end