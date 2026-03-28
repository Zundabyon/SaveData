FactoryBot.define do
  factory :user do
    email       { Faker::Internet.unique.email}
    password    { Faker::Internet.password(min_length: 6) }
    name        { Faker::Name.name }
    birthday    { Faker::Date.birthday }
    gender      { :male }
    job         { Faker::Job.title }
  end
end
