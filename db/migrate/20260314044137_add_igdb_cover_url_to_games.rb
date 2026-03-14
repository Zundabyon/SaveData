class AddIgdbCoverUrlToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :igdb_cover_url, :string
  end
end
