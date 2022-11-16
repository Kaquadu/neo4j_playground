defmodule Neo4jPlayground.Neo4jAdapter do
  @neo_repo Bolt.Sips

  def run_query(query) do
    try do
      %{records: records} = @neo_repo.query!(@neo_repo.conn, query)

      {:ok, records}
    rescue
      e in Bolt.Sips.Exception ->
        {:error, e.message}
    end
  end
end
