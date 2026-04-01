FactoryBot.define do
  factory :game do
    title { Faker::Game.title }
    hardware { Game::HARDWARE_OPTIONS.sample }
    genre { Game::GENRE_OPTIONS.sample }
    played_age { Game::PLAYED_AGE_OPTIONS.sample[1] }
    user
  end
end
