class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :state, default: 'not_started'
      t.integer :players_count
      t.integer :squares_count
      t.integer :board_size
      t.integer :min_players
      t.integer :max_players
      t.integer :winner_id

      t.timestamps
    end
  end
end
