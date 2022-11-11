defmodule Neo4jPlayground.Neo4jAdapter do
  @neo_repo Bolt.Sips

  def run_query(query) do
    try do
      {:ok, @neo_repo.query!(@neo_repo.conn, query)}
    rescue
      e in Bolt.Sips.Exception ->
        {:error, e.message}
    end
  end
end
