FROM ruby:3.2.2

# Node + Yarn（Rails用）
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app

# Gemfileを先にコピー（キャッシュ最適化）
COPY Gemfile Gemfile.lock ./

RUN bundle install

# アプリ本体コピー
COPY . .

# ポート
EXPOSE 3000

# 起動コマンド
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
