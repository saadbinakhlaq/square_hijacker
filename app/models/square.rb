class Square < ApplicationRecord
  belongs_to :game, counter_cache: true

  validates :number,
            presence: true,
          uniqueness: true

  scope :ordered, -> { order(:id) }

  def claim(player_id)
    if self.player_id.nil? && blockage_time_over?
      self.player_id = player_id
      self.game.last_claimed_square_time = Time.now
      self.save!
      self.game.save!
      Game.decrement_counter(:squares_count, self.game_id)

      return {
        success: true,
        result: 'Claimed'
      }
    elsif self.player_id.present?
      return { 
        success: false,
        result: 'Already claimed by another player'
      }
    else
      return {
        success: false,
        result: 'Blockage time is not over'
      }
    end
  end

  private

  def blockage_time_over?
    self.game.last_claimed_square_time.nil? || Time.now - self.game.last_claimed_square_time > self.game.blockage_time.seconds
  end
end
