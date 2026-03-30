FactoryBot.define do
  factory :user do
    email       { Faker::Internet.unique.email }
    password    { Faker::Internet.password(min_length: 6) }
    name        { Faker::Name.name }
    birthday    { Faker::Date.birthday }
    gender      { :male }
    job         { Faker::Job.title }
  # 追加する時はtraitを定義して、必要な属性を上書きする
  # google_oauth2でのユーザーを作成するためのtraitです
  # userだけでなく、Googleログインを通して作ったユーザーも必要なため
  # providerとuidはomniauthでユーザーを作成するために必要な属性です
  trait :google_oauth2 do
    provider { "google_oauth2" }
    uid { Faker::Number.number(digits: 10).to_s }
    birthday { nil }
    gender { nil }
    job { nil }
  end
 end
end
