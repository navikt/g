FROM ruby:3 AS builder

Run gem install bundler

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install


FROM ruby:3-slim

ENV "GRUNNBELOP" "./g.json"

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY --chown=1069:1069 lib lib
COPY --chown=1069:1069 config.ru .
COPY --chown=1069:1069 g.json .
COPY --chown=1069:1069 entrypoint.sh .

CMD ["./entrypoint.sh"]
