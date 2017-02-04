class Square < ApplicationRecord
  belongs_to :game, counter_cache: true

  validates :number,
            presence: true,
          uniqueness: true

  scope :ordered, -> { order(:id) }

  def claim(player_id)
    if self.player_id.present?
      return { 
        success: false,
        result: 'Already claimed by another player'
      }
    else
      self.player_id = player_id
      self.save!
      Game.decrement_counter(:squares_count, self.game_id)

      return {
        success: true,
        result: 'Claimed'
      }
    end
  end
end
