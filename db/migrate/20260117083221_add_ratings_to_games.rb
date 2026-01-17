class AddRatingsToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :fun, :integer
    # difficulty は追加しない（既にあるため）
  end
end
