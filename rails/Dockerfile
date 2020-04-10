FROM ruby:2.6.5-buster AS build-env

ARG environment=production
ENV RAILS_ENV $environment
ENV NODE_ENV production
ENV ACTIVE_STORAGE_SERVICE local
# Make sure the asset host is not present in compiled assets
ENV APP_HOST ""
ENV ASSET_HOST ""

# Install node and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y --no-install-recommends nodejs yarn

RUN mkdir /app && \
    mkdir -p /app/gems/recommendation_report
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler --no-document && bundle install --without development test --deployment --jobs 3

COPY . /app

# RUN bundle exec rails assets:precompile

FROM ruby:2.6.5-buster

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  nano nodejs yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

WORKDIR /app

COPY . /app
COPY --from=build-env /app/public /app/public
COPY --from=build-env /app/vendor/bundle /app/vendor/bundle
# Just in case
RUN gem install bundler --no-document && bundle install --without development test --deployment

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
