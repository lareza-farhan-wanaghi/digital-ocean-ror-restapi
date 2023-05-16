# Base image
FROM ruby:2.5.9

# Set up environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs sqlite3

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

## Install gems
RUN gem install bundler
RUN bundle install --without development test

# Copy the rest of the application code
COPY . .

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
# Migrate the database
RUN bundle exec rails db:migrate

# # Precompile assets (if needed)
# RUN rails assets:precompile

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]
