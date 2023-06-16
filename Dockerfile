FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /creating-an-app-from-scratch
COPY Gemfile /creating-an-app-from-scratch/Gemfile
COPY Gemfile.lock /creating-an-app-from-scratch/Gemfile.lock
RUN bundle install
COPY . /creating-an-app-from-scratch

EXPOSE 3000
