To build the container with docker

```
docker build -t game .
```

To run the container and mount the game volume

```
docker run -it -p 4000:4000 -v $(pwd):/game game
```

Install dependencies at the command line

```
mix deps.get
```

To run the web server and visit localhost:4000

```
mix phx.server
```

To run the tests

```
mix test.watch test/game/game_test.exs
```

To run all of the tests

```
mix test
```
