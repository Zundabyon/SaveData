FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.unique.email }
    password              { 'password123' }
    password_confirmation { 'password123' }  # ← 追加
    name        { Faker::Name.name }
    birthday    { Faker::Date.birthday }
    gender      { :male }
    job         { Faker::Job.title }

    trait :google_oauth2 do
      provider { "google_oauth2" }
      uid { Faker::Number.number(digits: 10).to_s }
      birthday { nil }
      gender { nil }
      job { nil }
    end
  end
end