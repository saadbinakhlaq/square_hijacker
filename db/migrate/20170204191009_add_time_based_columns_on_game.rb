class AddTimeBasedColumnsOnGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :blockage_time, :integer, default: 0
    add_column :games, :last_claimed_square_time, :timestamp
  end
end
