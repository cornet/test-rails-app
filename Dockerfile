# Include the Ruby base image (https://hub.docker.com/_/ruby)
# in the image for this application, version 2.7.1.
FROM ruby:3.0.3-slim

RUN set -e; \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y \
  nodejs \
  git \
  build-essential \
  cmake \
  curl \
  npm

RUN npm install --global yarn

# Put all this application's files in a directory called /code.
# This directory name is arbitrary and could be anything.
WORKDIR /code

# Copy the Gemfile over.
COPY Gemfile Gemfile.lock ./
COPY yarn.lock ./

# Run this command. RUN can be used to run anything. In our
# case we're using it to install our dependencies.
RUN bundle install
RUN yarn install

# Copy the rest of the code over after installing dependencies so we don't
# have to redo those steps when only the code has changed.
COPY . /code

# Tell Docker to listen on port 4567.
EXPOSE 4567

# Tell Docker that when we run "docker run", we want it to
# run the following command:
# $ bundle exec rackup --host 0.0.0.0 -p 4567.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "4567"]
