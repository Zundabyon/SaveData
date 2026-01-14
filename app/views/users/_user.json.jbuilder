json.extract! user, :id, :email, :name, :birthday, :gender, :crypted_password, :created_at, :updated_at
json.url user_url(user, format: :json)
