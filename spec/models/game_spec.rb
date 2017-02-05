require 'rails_helper'

describe Game do
  it { is_expected.to validate_presence_of(:board_size) }
  it { is_expected.to validate_presence_of(:min_players) }
  it { is_expected.to validate_presence_of(:max_players) }
  it { is_expected.to validate_presence_of(:state) }

  describe '#add_player' do
    it 'adds a player to the game' do
      game = create(:game)
      user = create(:user)
      player_name = 'something'
      
      expect {
        res = game.add_player(user, player_name)
        player = res[:result]
        expect(res[:success]).to be_truthy
        expect(player.name).to eq(player_name)
        expect(player.game).to eq(game)
        expect(game.players_count).to eq(1)
      }.to change { Player.count }.by(1)
    end

    context 'max_players reached' do
      it 'does not adds a player to the game and returns error message' do
        game = create(:game, players_count: 4, max_players: 4)
        user = create(:user)
        player_name = 'something'
        
        expect {
          res = game.add_player(user, player_name)
          expect(res[:success]).to be_falsey
          expect(res[:result]).to eq('max players reached for the game')
        }.to change { Player.count }.by(0)
      end
    end
  end

  describe '#player_in_game?' do
    it 'returns true if player is in the game else false' do
      game = create(:game)
      user = create(:user)
      game.add_player(user, 'player')

      expect(game.player_in_game?(user.id)).to eq(true)
    end
  end

  describe '#current_player' do
    it 'returns player if player is in the game else nil' do
      game = create(:game)
      user = create(:user)
      res = game.add_player(user, 'player')

      player = res[:result]
      expect(game.current_player(user)).to eq(player)
    end
  end

  describe '#start!' do
    context 'not_started' do
      it 'sets state of the game to started' do
        game = create(:game)
        game.start!

        expect(game.state).to eq('started')
      end
    end

    context 'ended' do
      it 'returns false with failure message' do
        game = create(:game, state: 'ended')
        res = game.start!

        expect(res[:success]).to be_falsey
        expect(res[:message]).to eq('Cannot transition from ended to started')
      end
    end
  end
end
