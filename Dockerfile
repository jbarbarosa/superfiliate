FROM ruby:3.3

WORKDIR /app

COPY Gemfile* ./

RUN BUNDLE_WITHOUT="local" bundle install

COPY lib ./lib

CMD ["ruby", "/app/lib/route/cart_route.rb"]
