defmodule GameWeb.GameLive do
  use Phoenix.LiveView

  alias GameWeb.Live.Component.Card

  def render(assigns) do
    ~L"""
      <div id="card-game" class="card-game">
        <div class="sticky-header">
          <header class="header header-game">
            <span class="label">Score: </span><span class="label-score"><%= assigns.score %></span>
          </header>
        </div>

        <div class="game-container">
          <div class="game">
            <div class="cards">
              <%= for card <- rows(assigns) do %>
                <%= live_component(@socket, Card, id: card.id, card: card) %>
              <% end %>
            </div>

            <%= if assigns.winner == true do %>
              <div class="splash">
                <div class="overlay"></div>
                <div class="content">
                  <h1>You Won!</h1>
                  <h2>Want more action?</h2>
                  <a class="icon-padding action-button animate margin-right green" href="javascript:void(0)" phx-click="prepare_restart">Play Again</a>
                  <a href="/" class="icon-padding action-button animate purple">Home</a>
                </div>
              </div>
            <% end %>

          </div>
        </div>
      </div>
    """
  end

  def mount(session, socket) do
    %{game_name: game_name} = session
    state = Game.Session.game_state(game_name)

    {:ok, set_state(socket, state, session)}
  end

  def rows(%{cards: cards}) do
    Enum.map(cards, &Map.from_struct(&1))
  end

  def handle_event("prepare_restart", _value, socket) do
    %{:game_name => game_name} = socket.assigns

    case Game.Session.session_pid(game_name) do
      pid when is_pid(pid) ->
        state = Game.Session.prepare_restart(game_name)
        send(self(), {:restart, game_name})
        {:noreply, set_state(socket, state, socket.assigns)}

      nil ->
        {:noreply, set_error(socket)}
    end
  end

  def handle_info({:flip, flip_id}, socket) do
    %{:game_name => game_name} = socket.assigns

    case Game.Session.session_pid(game_name) do
      pid when is_pid(pid) ->
        state = Game.Session.flip(game_name, flip_id)
        %Game.Engine{animating: animating} = state

        if animating == true do
          send(self(), {:unflip, game_name})
        end

        {:noreply, set_state(socket, state, socket.assigns)}

      nil ->
        {:noreply, set_error(socket)}
    end
  end

  def handle_info({:unflip, game_name}, socket) do
    case Game.Session.session_pid(game_name) do
      pid when is_pid(pid) ->
        state = Game.Session.unflip(game_name)

        {:noreply, set_state(socket, state, socket.assigns)}

      nil ->
        {:noreply, set_error(socket)}
    end
  end

  def handle_info({:restart, game_name}, socket) do
    case Game.Session.session_pid(game_name) do
      pid when is_pid(pid) ->
        state = Game.Session.restart(game_name)

        {:noreply, set_state(socket, state, socket.assigns)}

      nil ->
        {:noreply, set_error(socket)}
    end
  end

  def set_state(socket, state, %{game_name: game_name}) do
    %Game.Engine{cards: cards, winner: winner, score: score} = state

    assign(socket,
      game_name: game_name,
      cards: cards,
      winner: winner,
      score: score
    )
  end

  def set_error(socket) do
    assign(socket,
      error: "an error occurred"
    )
  end
end
