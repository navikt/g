FROM ruby:3.3 AS builder

Run gem install bundler

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install


FROM ruby:3.3-slim

ENV "GRUNNBELOP" "./grunnbeløp.json"
ENV "ENGANGSSTONAD" "./engangsstønad.json"

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY --chown=1069:1069 lib lib
COPY --chown=1069:1069 config.ru .
COPY --chown=1069:1069 grunnbeløp.json .
COPY --chown=1069:1069 engangsstønad.json .
COPY --chown=1069:1069 entrypoint.sh .

CMD ["./entrypoint.sh"]
