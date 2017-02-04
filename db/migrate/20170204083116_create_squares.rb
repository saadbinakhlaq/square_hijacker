class CreateSquares < ActiveRecord::Migration[5.0]
  def change
    create_table :squares do |t|
      t.integer :number
      t.references :game, foreign_key: true
      t.integer :player_id

      t.timestamps
    end
  end
end
