defmodule Neo4jPlayground.Neo4j.Connection do
  use GenServer

  require Logger

  @impl true
  def init(_params) do
    neo4j_opts = Application.get_env(:bolt_sips, Bolt)

    # returns {:ok, pid} tuple
    Bolt.Sips.start_link(neo4j_opts)
  end

  @impl true
  def handle_call(:get_conn, _from, pid) do
    {:reply, pid, pid}
  end

  ###

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
