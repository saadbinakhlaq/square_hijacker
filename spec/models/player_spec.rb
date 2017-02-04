require 'rails_helper'

describe Player do
  it { should belong_to(:game) }
  it { should belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }

  it 'validate a user does not join a game twice' do
    user = create(:user)
    game = create(:game)
    player = create(:player, user: user, game: game)

    expect{
      create(:player, user: user, game: game)
    }.to raise_error(ActiveRecord::RecordInvalid, /You are already in this game/)
  end  
end
