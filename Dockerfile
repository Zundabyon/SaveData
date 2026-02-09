FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client && \
    npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Build assets with environment-aware settings
RUN export RAILS_ENV=production && \
    export NODE_ENV=production && \
    export SECRET_KEY_BASE=dummy && \
    yarn install && \
    yarn build:css && \
    yarn build && \
    bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
