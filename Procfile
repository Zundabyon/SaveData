web: bin/rails server -b 0.0.0.0 -p ${PORT:-3000}
release: yarn install && yarn build:css && bin/rails assets:precompile