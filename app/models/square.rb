class Square < ApplicationRecord
  belongs_to :game, counter_cache: true
end
