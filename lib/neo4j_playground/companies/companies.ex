defmodule Neo4jPlayground.Companies do
  alias Neo4jPlayground.Neo4jAdapter
  alias Neo4jPlayground.Companies.Company

  def create(params) do
    case Company.changeset(%Company{}, params) do
      %{valid?: true} = cs ->
        query = "CREATE (company:Company #{build_company_params!(cs)}) RETURN company"

        Neo4jAdapter.run_query(query)

      _invalid = cs ->
        {:error, cs}
    end
  end

  # for testing purposes
  def delete_all() do
    Neo4jAdapter.run_query("MATCH (companies:Company) DETACH DELETE (companies)")
  end

  ###

  defp build_company_params!(%{changes: changes} = _cs) do
    raw_params =
      changes
      |> Enum.reduce("", fn {k, v}, acc ->
        acc <> "#{k}: '#{v}', "
      end)
      |> String.replace_suffix(", ", "")

    "{#{raw_params}}"
  end
end
