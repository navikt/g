FROM ruby:3.2

ENV "GRUNNBELØP" "./grunnbeløp.json"

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=1069:1069 . .

CMD ["./entrypoint.sh"]
