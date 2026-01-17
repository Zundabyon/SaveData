class AddPlayedInfoToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :played_year, :integer
    add_column :games, :played_age, :integer
  end
end
