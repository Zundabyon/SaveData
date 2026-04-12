# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :date
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
