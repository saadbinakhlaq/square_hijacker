FactoryGirl.define do
  factory :game do
    state 'not_started'
    players_count 4
    squares_count 4
    board_size 4
    min_players 2
    max_players 4
    winner_id nil
  end
end
