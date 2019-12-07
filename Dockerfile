FROM elixir:1.9.1

RUN mix local.hex --force
RUN mix local.rebar --force

VOLUME /game
WORKDIR /game

RUN apt-get update
RUN apt-get install inotify-tools -y

ENTRYPOINT ["/bin/bash"]

EXPOSE 4000
