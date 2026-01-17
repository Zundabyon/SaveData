class FixGamesColumns < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :genre, :string unless column_exists?(:games, :genre)

    remove_column :games, :type, :string if column_exists?(:games, :type)
  end
end
