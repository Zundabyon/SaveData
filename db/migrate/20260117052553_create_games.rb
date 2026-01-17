class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.string :hardware
      t.string :genre
      t.string :recommended
      t.string :difficulty
      t.integer :ended_year
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
