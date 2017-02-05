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

  describe '#end!' do
    context 'not_started' do
      it 'sets state of the game to started' do
        game = create(:game)
        result = game.end!

        expect(game.state).to eq('not_started')
        expect(result[:success]).to be_falsey
      end
    end

    context 'started' do
      it 'ends the game' do
        game = create(:game, state: 'started')
        result = game.end!

        expect(game.state).to eq('ended')
        expect(result[:success]).to be_truthy
      end
    end
  end

  describe '#square_claimed_by' do
    it 'returns player which claimed the square' do
      game = create(:game)
      user = create(:user)
      player = create(:player, user: user, game: game)
      square = create(:square, number: 1, player_id: player.id, game: game)

      expect(game.square_claimed_by(square.id)).to eq(player)
    end
  end

  describe '#assign_winner' do
    it 'assigns winner' do
      game = create(:game)
      user = create(:user)
      player = create(:player, user: user, game: game)

      expect{
        game.assign_winner(player.id)
      }.to change { game.winner_id }.to(player.id)
    end
  end

  describe '#winner' do
    it 'returns player with winner_id if game has ended' do
      game = create(:game)
      user = create(:user)
      player = create(:player, user: user, game: game)
      game.winner_id = player.id
      game.save
      expect(game.winner).to eq(player)
    end
  end
end
