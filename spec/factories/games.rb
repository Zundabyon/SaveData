# == Schema Information
#
# Table name: games
#
#  id             :bigint           not null, primary key
#  difficulty     :integer
#  ended_year     :integer
#  fun            :integer
#  genre          :string
#  hardware       :string
#  igdb_cover_url :string
#  memo           :text
#  played_age     :integer
#  played_year    :integer
#  recommended    :string
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_games_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :game do
    title { Faker::Game.title }
    hardware { Game::HARDWARE_OPTIONS.sample }
    genre { Game::GENRE_OPTIONS.sample }
    played_age { Game::PLAYED_AGE_OPTIONS.sample[1] }
    user
  end
end
