FROM ruby:2.3

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    autoconf ghostscript gsfonts imagemagick jhead jpegoptim libbz2-dev libfreetype6-dev libjpeg-dev libjpeg-turbo-progs libtiff-dev libxml2 nodejs npm optipng pkg-config postgresql-client \
    gifsicle pngquant \
  && ln --symbolic /usr/bin/nodejs /usr/bin/node \
  && rm -rf /var/lib/apt/lists/*

RUN npm install --global \
  svgo uglify-js

WORKDIR /usr/src/app

ARG DISCOURSE_VERSION=1.6.0.beta11

RUN curl -sfSL https://github.com/discourse/discourse/archive/v${DISCOURSE_VERSION}.tar.gz \
  | tar -zx --strip-components=1 -C /usr/src/app

ENV RAILS_ENV=production \
  RUBY_GC_MALLOC_LIMIT=90000000 \
  RUBY_GLOBAL_METHOD_CACHE_SIZE=131072

RUN bundle config build.nokogiri --use-system-libraries \
  && bundle install --deployment --without test --without development

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
