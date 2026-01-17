class ChangeDifficultyTypeInGames < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      ALTER TABLE games
      ALTER COLUMN difficulty
      TYPE integer
      USING difficulty::integer;
    SQL
  end

  def down
    change_column :games, :difficulty, :string
  end
end
