FROM ruby:2.6.5-alpine
ENV RAILS_LOG_TO_STDOUT=1

# https://github.com/arwineap/docker-rubyalpine-nokogiri/blob/master/Dockerfile
# https://github.com/andrius/alpine-ruby/blob/master/Dockerfile-3.7
# pre install native extensions like nokogiri pg bcrypt
RUN apk add --no-cache --virtual .build-deps \
  build-base \
  libxml2-dev libxslt-dev \
&& apk add --no-cache tzdata postgresql-dev \
&& gem install rails -v 6.0.2.1 \
&& gem install bundler \
&& gem install bcrypt \
&& rails new /tmp/dummy --database=postgresql --skip-sprockets --webpack --skip-git --skip-bundle --skip-webpack-install  \
&& cd /tmp/dummy \
&& bundle install --without development test \
&& cp Gemfile.lock / \
&& cd - \
&& gem cleanup \
&& apk del .build-deps \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/* \
          ~/.bundle/cache
