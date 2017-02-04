class Game < ApplicationRecord
  validates :board_size,
            presence: true
  validates :min_players,
            presence: true
  validates :max_players,
            presence: true
  validates :state,
            presence: true

  STATES = %w(not_started started ended)

  has_many :squares
end
