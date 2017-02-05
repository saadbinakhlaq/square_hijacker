class Game < ApplicationRecord
  validates :board_size,
            presence: true
  validates :min_players,
            presence: true
  validates :max_players,
            presence: true
  validates :state,
            presence: true

  STATES = %w(not_started started ended).freeze

  has_many :players, dependent: :destroy
  has_many :squares, dependent: :destroy

  scope :ordered, -> { order(:created_at) }

  def add_player(user, player_name)
    if self.players_count == self.max_players
      return {
        success: false,
        result: 'max players reached for the game'
      }
    else
      player = self.players.create(user: user, name: player_name)

      return {
        success: true,
        result: player
      }
    end
  end

  def player_in_game?(user_id)
    players = self.players

    players.map(&:user).map(&:id).include?(user_id)
  end

  def current_player(user)
    self.players.find { |player| player.user == user }
  end

  def over?
    self.state == 'ended'
  end

  def started?
    self.state == 'started'
  end

  def start!
    case self.state
    when 'not_started'
      self.state = STATES.second
      self.save!
      return {
        success: true,
        message: 'Game has started'
      }
    when 'ended'
      return {
        success: false,
        message: 'Cannot transition from ended to started'
      }
    end
  end

  def end!
    case self.state
    when 'started'
      self.state = STATES.last
      self.save!
      return {
        success: true,
        message: 'Game has ended'
      }
    when 'not_started'
      return {
        success: false,
        message: 'Game has not started'
      }
    end
  end
end