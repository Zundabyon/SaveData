#!/usr/bin/env bash
set -ex

bundle install
yarn install
yarn precompile
bundle exec rake assets:precompile
