require 'rails_helper'

describe Game do
  it { is_expected.to validate_presence_of(:board_size) }
  it { is_expected.to validate_presence_of(:min_players) }
  it { is_expected.to validate_presence_of(:max_players) }
  it { is_expected.to validate_presence_of(:state) }

end
