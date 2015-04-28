# Dockerfile for X86_64
FROM ruby
MAINTAINER Matt Williams <matt@matthewkwilliams.com>
ADD app /app
WORKDIR /app
EXPOSE 80
RUN bundle install
ENV REDIS_URL=redis://redis:6379/0
CMD ['bundle','exec','app.rb']
