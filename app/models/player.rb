class Player < ApplicationRecord
  belongs_to :game, counter_cache: true
  belongs_to :user

  alias_attribute :joined, :created_at

  validates :name,
         presence: true

  validates :user,
       uniqueness: { scope: :game, 
                     message: 'Validation failed: You are already in this game' },
         presence: true

  validates :game_id,
         presence: true

  validates :user_id,
          presence: true

  scope :ordered, -> { order(:created_at) }
end
