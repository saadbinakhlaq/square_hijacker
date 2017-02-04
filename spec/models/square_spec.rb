require 'rails_helper'

describe Square do
  it { is_expected.to validate_uniqueness_of(:number) }
  it { is_expected.to validate_presence_of(:number) }

  describe '#claim' do
    context 'not claimed' do
      it 'returns true' do
        game = create(:game_with_squares, state: 'started')
        square = game.squares.first

        user = create(:user)
        player = create(:player, game: game, user: user)

        expect {
          square.claim(player.id)
          expect(square.reload.player_id).to eq(player.id)
        }.to change { game.reload.squares_count }.by(-1)
      end
    end

    context 'already claimed' do
      it 'returns false and error message' do
        game = create(:game_with_squares, state: 'started')
        square = game.squares.first

        user = create(:user)
        player = create(:player, game: game, user: user)
        square.claim(player.id)

        expect {
          response = square.claim(player.id)
          expect(response[:success]).to be_falsey
        }.to change { game.reload.squares_count }.by(0)
      end
    end
  end
end
