defmodule Neo4jPlayground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Neo4jPlayground.Neo4j.Connection
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Neo4jPlayground.Supervisor)
  end
end
