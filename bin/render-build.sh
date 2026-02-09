#!/usr/bin/env bash
set -ex

export RAILS_ENV=production
export NODE_ENV=production

bundle install
yarn install
yarn build:css
yarn build
RAILS_ENV=production bundle exec rake assets:precompile
