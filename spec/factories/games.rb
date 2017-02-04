FactoryGirl.define do
  factory :game do
    state 'not_started'
    players_count 0
    squares_count 0
    board_size 4
    min_players 2
    max_players 4
    winner_id nil

    factory :game_with_squares do
      transient do
        squares_count 4
      end

      after(:create) do |game, evaluator|
        (1..evaluator.squares_count).each do |i|
          create(:square, number: i, game: game)
        end
      end
    end
  end
end
