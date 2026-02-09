FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client && \
    npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Build assets with environment-aware settings
RUN mkdir -p public/images && cp -R app/assets/images/* public/images/ || true
RUN export RAILS_ENV=production && \
    export NODE_ENV=production && \
    yarn install && \
    yarn build:css && \
    yarn build && \
    bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
