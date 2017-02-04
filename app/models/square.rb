class Square < ApplicationRecord
  belongs_to :game, counter_cache: true

  validates :number,
            presence: true,
          uniqueness: true
end
