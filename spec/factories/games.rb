FactoryBot.define do
  factory :game do
    title { Faker::Game.title }
    played_age { rand(0..120) }
    fun { rand(1..5) }
    difficulty { rand(1..5) }
    hardware { Game::HARDWARE_OPTIONS.sample }
    genre { Game::GENRE_OPTIONS.sample }
    memo { Faker::Lorem.sentence }
    association :user
  end
end

