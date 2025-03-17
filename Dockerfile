# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:3.1.0-slim

# Define where our application will live inside the image
ENV RAILS_ROOT /var/www/dumbledore
ENV RAILS_ENV development

# Install essential Linux packages
RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev postgresql-client git vim libvips curl \
  && gem install rails -v 7.0.4 \
  && gem install bundler -v 2.3.5 \
  && mkdir -p $RAILS_ROOT/tmp/pids 

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Finish establishing our Ruby enviornment
RUN bundle install

# Copy the Rails application into place
COPY . .

CMD (bundle check || bundle install) && (rm -f tmp/pids/server.pid) && bin/rails s -b 0.0.0.0
