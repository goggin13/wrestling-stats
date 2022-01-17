# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:3.1.0-slim

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client libsqlite3-dev git

RUN gem install rails -v 7.0.1

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler -v 2.3.5

# Define where our application will live inside the image
ENV RAILS_ROOT /var/www/wrestling-stats
ENV RAILS_ENV development

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock

# Copy the Rails application into place
COPY . .

# Finish establishing our Ruby enviornment
RUN bundle install

CMD (bundle check || bundle install) && bundle exec rails s -b 0.0.0.0
