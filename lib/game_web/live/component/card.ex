defmodule GameWeb.Live.Component.Card do
  use Phoenix.LiveComponent

  @defaults %{
    id: nil,
    name: "",
    image: "",
    paired: false,
    flipped: false
  }

  def render(assigns) do
    ~L"""
      <div class="card <%= clazz(@card) %>" phx-click="flip" phx-value-flip-id=<%= @card.id %>>
        <div class="back"></div>
        <div class="front" style="background-image: url(<%= @card.image %>)"></div>
      </div>
    """
  end

  def mount(_assigns, socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def handle_event("flip", %{"flip-id" => flip_id}, socket) do
    send(self(), {:flip, flip_id})

    {:noreply, socket}
  end

  def clazz(%{flipped: flipped, paired: paired}) do
    case paired == true do
      true ->
        "found"

      false ->
        case flipped == true do
          true -> "flipped"
          false -> ""
        end
    end
  end
end
