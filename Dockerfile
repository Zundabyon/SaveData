FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client && \
    npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Note: Assets precompilation handled by Render's buildCommand (render.yaml)
# in production. For local Docker development, use: docker compose up

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
