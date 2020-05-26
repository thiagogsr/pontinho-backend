FROM elixir:1.10-alpine as build

# prepare build dir
WORKDIR /pontinho

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# install build dependencies
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache build-base zip git

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies and build project
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
RUN mix do deps.get, deps.compile, compile

# build release
RUN mix release --overwrite

RUN cd /pontinho/_build/prod/rel/web; zip --quiet -r /pontinho/pontinho.zip *

# prepare release image
FROM alpine:latest AS app

WORKDIR /pontinho

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache ncurses unzip

COPY --from=build /pontinho/pontinho.zip ./

RUN unzip -q pontinho.zip

CMD /pontinho/bin/web start
