defmodule Game.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GameWeb.Endpoint,
      {Registry, keys: :unique, name: Game.Registry},
      Game.SessionSupervisor
    ]

    opts = [strategy: :one_for_one, name: Game.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    GameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
