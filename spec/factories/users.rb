# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :date
#  crypted_password       :integer
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  gender                 :integer
#  job                    :string
#  name                   :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
